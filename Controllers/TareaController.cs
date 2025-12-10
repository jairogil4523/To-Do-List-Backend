using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using To_Do_List.Models;

namespace To_Do_List.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class TareaController
    {
        [HttpGet]
        public Task<ActionResult<IEnumerable<Tarea>>> GetTareas()
        {
            
            return Task.FromResult<ActionResult<IEnumerable<Tarea>>>(new List<Tarea>());
        }
    }
}
