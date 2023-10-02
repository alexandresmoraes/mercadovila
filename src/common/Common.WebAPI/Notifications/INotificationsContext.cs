using Common.WebAPI.Results;

namespace Common.WebAPI.Notifications
{
  public interface INotificationsContext
  {
    ResultNotifications Notifications { get; }

    bool HasErrors { get; }
    bool HasWarnings { get; }
    bool HasInformations { get; }

    IEnumerable<ErrorResult> Errors { get; }
    IEnumerable<WarningResult> Warnings { get; }
    IEnumerable<InformationResult> Informations { get; }

    void AddError(string message);
    void AddWarning(string message);
    void AddInformation(string message);
  }
}