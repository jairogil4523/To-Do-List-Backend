using Microsoft.AspNetCore.SignalR;

namespace To_Do_List.Models
{
    public class Tarea
    {
        public int Id { get; set; }

        // Título de la tarea
        public string Titulo { get; set; }

        // Descripción opcional
        public string? Descripcion { get; set; }

        // Estado de completada
        public bool Completada { get; set; }

        // Usuario propietario
        public string UserId { get; set; }

        // Fecha de creación
        public DateTime FechaCreacion { get; set; }

        // Fecha de actualización (nullable)
        public DateTime? FechaActualizacion { get; set; }
    }
}
