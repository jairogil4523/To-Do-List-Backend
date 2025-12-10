using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
// Authentication disabled for these endpoints per user request
using To_Do_List.Data;
using To_Do_List.Models;

namespace To_Do_List.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TareasController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TareasController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            var tareas = _context.Tareas.ToList();
            return Ok(tareas);
        }

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var tarea = _context.Tareas.Find(id);
            if (tarea == null) return NotFound();
            return Ok(tarea);
        }

        public class CreateTareaRequest
        {
            public string Titulo { get; set; }
            public string? Descripcion { get; set; }
            public string UserId { get; set; }
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateTareaRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Titulo) || string.IsNullOrWhiteSpace(request.UserId))
                return BadRequest("Titulo y UserId son requeridos.");

            var tarea = new Tarea
            {
                Titulo = request.Titulo,
                Descripcion = request.Descripcion,
                UserId = request.UserId,
                Completada = false,
                FechaCreacion = DateTime.UtcNow,
                FechaActualizacion = null
            };

            _context.Tareas.Add(tarea);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = tarea.Id }, tarea);
        }

        public class UpdateTareaRequest
        {
            public string Titulo { get; set; }
            public string? Descripcion { get; set; }
            public bool Completada { get; set; }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromBody] UpdateTareaRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Titulo))
                return BadRequest("Titulo es requerido.");

            var tarea = await _context.Tareas.FindAsync(id);
            if (tarea == null) return NotFound();
            // Authentication removed: allow update without user check
            tarea.Titulo = request.Titulo;
            tarea.Descripcion = request.Descripcion;
            tarea.Completada = request.Completada;
            tarea.FechaActualizacion = DateTime.UtcNow;

            _context.Tareas.Update(tarea);
            await _context.SaveChangesAsync();

            return Ok(tarea);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var tarea = await _context.Tareas.FindAsync(id);
            if (tarea == null) return NotFound();
            // Authentication removed: allow delete without user check
            _context.Tareas.Remove(tarea);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
