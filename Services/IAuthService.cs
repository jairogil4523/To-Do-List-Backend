using To_Do_List.Models;

namespace To_Do_List.Services
{
    public interface IAuthService
    {
        Task<string?> AuthenticateAsync(AuthRequest request);
    }
}
