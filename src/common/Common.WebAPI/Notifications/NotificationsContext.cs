using Common.WebAPI.Results;

namespace Common.WebAPI.Notifications
{
  public class NotificationsContext : INotificationsContext
  {
    private ResultNotifications _notifications = new();

    public ResultNotifications Notifications => _notifications;
    public bool HasErrors => _notifications.HasErrors;

    public bool HasWarnings => _notifications.HasWarnings;

    public bool HasInformations => _notifications.HasInformations;

    public IEnumerable<ErrorResult> Errors => _notifications.Errors;

    public IEnumerable<WarningResult> Warnings => _notifications.Warnings;

    public IEnumerable<InformationResult> Informations => _notifications.Informations;

    public void AddError(string message)
      => _notifications.Errors.Add(new ErrorResult(null, null, message));

    public void AddInformation(string message)
      => _notifications.Informations.Add(new InformationResult(message));

    public void AddWarning(string message)
      => _notifications.Warnings.Add(new WarningResult(message));
  }
}
