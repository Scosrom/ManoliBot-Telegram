import tkinter as tk
from tkinter import messagebox

def display_file_content(file_path):
    try:
        with open(file_path, "r") as file:
            content = file.read()
            text_box.delete("1.0", tk.END)  # Limpiar el contenido actual del cuadro de texto
            text_box.insert(tk.END, content)
            button_text.set(file_path)
    except FileNotFoundError:
        text_box.delete("1.0", tk.END)  # Limpiar el contenido actual del cuadro de texto
        text_box.insert(tk.END, "El archivo no existe.")

def save_file_content():
    file_path = button_text.get()
    if not file_path:
        messagebox.showerror("Error", "No se ha seleccionado ningún archivo.")
        return

    content = text_box.get("1.0", tk.END)
    with open(file_path, "w") as file:
        file.write(content)
    messagebox.showinfo("Guardado", "Contenido guardado exitosamente.")

def create_gui():
    root = tk.Tk()
    root.title("ManoliBot-1.0")
    root.configure(bg="gray")

    # Frame para los botones
    button_frame = tk.Frame(root, bg="gray")
    button_frame.pack()

    # Crear botones para cada archivo
    file_buttons = {
        "Comandos Ejecutados": "/opt/ManoliBot/inf/MensajesManoli.txt",
        "Hosts": "/opt/ManoliBot/hosts/hosts.txt",
        "Comandos Prohibidos": "/opt/ManoliBot/control/forbidden_commands.txt",
        "Administradores": "/opt/ManoliBot/adm/allowed_chat_ids.txt"
    }

    for idx, (label, file_path) in enumerate(file_buttons.items(), start=1):
        button = tk.Button(button_frame, text=label, command=lambda path=file_path: display_file_content(path))
        button.configure(bg="white", fg="black", activebackground="green", activeforeground="white", width=25)
        button.grid(row=(idx - 1) // 2, column=(idx - 1) % 2, pady=5, padx=5)

    # Cuadro de texto para mostrar y editar el contenido del archivo
    global text_box
    text_box = tk.Text(root, height=20, width=80)
    text_box.configure(bg="white", fg="black")
    text_box.pack()

    # Botón para guardar cambios en el archivo
    save_button = tk.Button(root, text="Guardar Cambios", command=save_file_content)
    save_button.configure(bg="white", fg="black", activebackground="green", activeforeground="white", width=25)
    save_button.pack(pady=5)

    # Etiqueta para el nombre del archivo seleccionado
    global button_text
    button_text = tk.StringVar()
    file_label = tk.Label(root, textvariable=button_text)
    file_label.configure(bg="gray", fg="black")
    file_label.pack(pady=5)

    # Ejecutar la aplicación
    root.mainloop()

# Llamar a la función para crear y mostrar la interfaz gráfica
create_gui()
