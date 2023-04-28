namespace Common.WebAPI.Auth
{
  public record AuthSettings
  {
    public string SecretKey { get; set; } = null!;
    public string Issuer { get; set; } = null!;
    public string Audience { get; set; } = null!;
    public int ExpiresIn { get; set; } = 3600;
    public DateTime IssuedAt => DateTime.UtcNow;
    public int RefreshTokenExpiration { get; set; } = 7;
    public int MaxFailedAccessAttempts { get; set; } = 5;
  }
}
