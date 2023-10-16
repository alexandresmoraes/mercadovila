using Common.EventBus.Abstractions;

namespace Common.EventBus;

public partial class EventBusSubscriptionsManager : IEventBusSubscriptionsManager
{
  public class SubscriptionInfo
  {
    public Type HandlerType { get; }

    private SubscriptionInfo(Type handlerType)
    {
      HandlerType = handlerType;
    }

    public static SubscriptionInfo Typed(Type handlerType) =>
      new SubscriptionInfo(handlerType);
  }
}
