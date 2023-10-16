﻿using Common.EventBus.Abstractions;
using Common.EventBus.Integrations.IntegrationEvents;

namespace Common.EventBus;

public partial class EventBusSubscriptionsManager : IEventBusSubscriptionsManager
{
  private readonly Dictionary<string, List<SubscriptionInfo>> _handlers;
  private readonly List<Type> _eventTypes;

  public event EventHandler<string>? OnEventRemoved;

  public EventBusSubscriptionsManager()
  {
    _handlers = new Dictionary<string, List<SubscriptionInfo>>();
    _eventTypes = new List<Type>();
  }

  public bool IsEmpty => _handlers is { Count: 0 };
  public void Clear() => _handlers.Clear();


  public void AddSubscription<T, TH>()
      where T : IntegrationEvent
      where TH : IIntegrationEventHandler<T>
  {
    var eventName = GetEventKey<T>();

    DoAddSubscription(typeof(TH), eventName);

    if (!_eventTypes.Contains(typeof(T)))
    {
      _eventTypes.Add(typeof(T));
    }
  }

  private void DoAddSubscription(Type handlerType, string eventName)
  {
    if (!HasSubscriptionsForEvent(eventName))
    {
      _handlers.Add(eventName, new List<SubscriptionInfo>());
    }

    if (_handlers[eventName].Any(s => s.HandlerType == handlerType))
    {
      throw new ArgumentException(
          $"Handler Type {handlerType.Name} already registered for '{eventName}'", nameof(handlerType));
    }

    _handlers[eventName].Add(SubscriptionInfo.Typed(handlerType));
  }


  public void RemoveSubscription<T, TH>()
      where TH : IIntegrationEventHandler<T>
      where T : IntegrationEvent
  {
    var handlerToRemove = FindSubscriptionToRemove<T, TH>();
    if (handlerToRemove is not null)
    {
      var eventName = GetEventKey<T>();
      DoRemoveHandler(eventName, handlerToRemove);
    }
  }

  private void DoRemoveHandler(string eventName, SubscriptionInfo subsToRemove)
  {
    if (subsToRemove is not null)
    {
      _handlers[eventName].Remove(subsToRemove);
      if (!_handlers[eventName].Any())
      {
        _handlers.Remove(eventName);
        var eventType = _eventTypes.SingleOrDefault(e => e.Name == eventName);
        if (eventType is not null)
        {
          _eventTypes.Remove(eventType);
        }
        RaiseOnEventRemoved(eventName);
      }
    }
  }

  public IEnumerable<SubscriptionInfo> GetHandlersForEvent<T>() where T : IntegrationEvent
  {
    var key = GetEventKey<T>();
    return GetHandlersForEvent(key);
  }
  public IEnumerable<SubscriptionInfo> GetHandlersForEvent(string eventName) => _handlers[eventName];

  private void RaiseOnEventRemoved(string eventName)
  {
    var handler = OnEventRemoved;
    handler?.Invoke(this, eventName);
  }

  private SubscriptionInfo? FindSubscriptionToRemove<T, TH>()
          where T : IntegrationEvent
          where TH : IIntegrationEventHandler<T>
  {
    var eventName = GetEventKey<T>();
    return DoFindSubscriptionToRemove(eventName, typeof(TH));
  }

  private SubscriptionInfo? DoFindSubscriptionToRemove(string eventName, Type handlerType)
  {
    if (!HasSubscriptionsForEvent(eventName))
    {
      return null;
    }

    return _handlers[eventName].SingleOrDefault(s => s.HandlerType == handlerType);

  }

  public bool HasSubscriptionsForEvent<T>() where T : IntegrationEvent
  {
    var key = GetEventKey<T>();
    return HasSubscriptionsForEvent(key);
  }

  public bool HasSubscriptionsForEvent(string eventName) => _handlers.ContainsKey(eventName);

  public Type? GetEventTypeByName(string eventName) => _eventTypes.SingleOrDefault(t => t.Name == eventName);

  public string GetEventKey<T>() => typeof(T).Name;
}