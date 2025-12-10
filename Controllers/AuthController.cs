using Microsoft.AspNetCore.Mvc;
using To_Do_List.Models;
using To_Do_List.Services;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace To_Do_List.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] AuthRequest request)
        {
            var token = await _authService.AuthenticateAsync(request);
            if (token == null) return Unauthorized();

            return Ok(new { token });
        }
    }
}
