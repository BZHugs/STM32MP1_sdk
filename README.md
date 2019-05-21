# STM32MP1_sdk

## Cross compile example

* make new folder ex: ```hello_world```
```mkdir hello_world && cd hello_world```

* create a file ```gtk_hello_world.c```
```sudo nano gtk_hello_world.c```

* write this exemple:

```
#include <gtk/gtk.h>

static void
print_hello (GtkWidget *widget,
             gpointer   data)
{
  g_print ("Hello World\n");
}

static void
activate (GtkApplication *app,
          gpointer        user_data)
{
  GtkWidget *window;
  GtkWidget *button;
  GtkWidget *button_box;

  window = gtk_application_window_new (app);
  gtk_window_set_title (GTK_WINDOW (window), "Window");
  gtk_window_set_default_size (GTK_WINDOW (window), 200, 200);

  button_box = gtk_button_box_new (GTK_ORIENTATION_HORIZONTAL);
  gtk_container_add (GTK_CONTAINER (window), button_box);

  button = gtk_button_new_with_label ("Hello World");
  g_signal_connect (button, "clicked", G_CALLBACK (print_hello), NULL);
  g_signal_connect_swapped (button, "clicked", G_CALLBACK (gtk_widget_destroy), window);
  gtk_container_add (GTK_CONTAINER (button_box), button);

  gtk_widget_show_all (window);
}

int
main (int    argc,
      char **argv)
{
  GtkApplication *app;
  int status;

  app = gtk_application_new ("org.gtk.example", G_APPLICATION_FLAGS_NONE);
  g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
  status = g_application_run (G_APPLICATION (app), argc, argv);
  g_object_unref (app);

  return status;
}
```
* create the ```Makefile```
```sudo nano Makefile```

* write this exemple:

```
PROG = gtk_hello_world
SRCS = gtk_hello_world.c

CLEANFILES = $(PROG)

# Add / change option in CFLAGS and LDFLAGS
CFLAGS += -Wall $(shell pkg-config --cflags gtk+-3.0)
LDFLAGS += $(shell pkg-config --libs gtk+-3.0)

all: $(PROG)

$(PROG): $(SRCS)
	$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

clean:
	rm -f $(CLEANFILES) $(patsubst %.c,%.o, $(SRCS))
```

* run docker with these args :

```
sudo docker run -it --rm -v "$(pwd)":/tmp jouetrom/stm32mp1_sdk:latest
```

* place you in the ```/tmp``` folder (inside the docker):

```cd /tmp```

* then make
```make```

* now exit the docker

```exit```

Normaly now you have the file compiled for the card

```ls gtk_hello_world```

you can send the compiled file via scp:

```scp gtk_hello_world root@172.17.1.62:/home/root/```



## Tips if route 172.17.X.X was already used.

```sudo nano /etc/docker/daemon.json```

```
{
  "default-address-pools":
  [
    {"base":"10.10.0.0/16","size":24}
  ]
}
```

then do

```sudo systemctl restart docker.service```
