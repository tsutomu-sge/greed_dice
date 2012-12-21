#Listens to events and dispatches them to registered observers for that
#particular event type.
class Reactor
  def initialize
    @observers = {}
  end

  def register(observer, event_classes)
    # puts "register #{observer} => #{event_classes}"
    @observers[observer]=event_classes
  end

  def unregister(observer)
    @observers.delete(observer)
  end

  def push_event(event)
    @observers.keys.each do |observer|
    # puts "push_event #{event}: #{event.class}: #{@observers[observer].include?event.class}"
      if @observers[observer].include?event.class
        observer.handle_event(event)
      end
    end
  end
end
