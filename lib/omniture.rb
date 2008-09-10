class Omniture
  
  attr_accessor :events, :evars, :props, :is_flushed
  
  def initialize
    reset
  end
  
  def reset
    @events = []
    @evars = {}
    @props = {}
    @is_flushed = true
  end
  
  def add_events(events)
    @is_flushed = false
    events.each do |event|
      event = event.to_s
      @events << ::EVENTS[event] if ::EVENTS.has_key? event
    end
  end
  
  def add_props(props)
    @is_flushed = false
    props.stringify_keys.each_pair do |key, value|
      @props[::PROPS[key]] = value if ::PROPS.has_key? key
    end
  end
  
  def add_event_variables(pairs)
    @is_flushed = false
    pairs.stringify_keys.each_pair do |key, value|
      @evars[::EVARS[key]] = value if ::EVARS.has_key? key
    end
  end
  
  def print_js_code(events=nil, evars=nil)
    events_current = @events
    evars_current = @evars
    if events
      add_events(events)
    end
    if evars
      add_event_variables(evars)
    end
    
    out = "var s=s_gi('hotchalkdev'); "
    out << print_events
    out << print_evars
    out << print_props
    out << <<-HTML
      s.linkTrackVars='prop10,eVar23,campaign,eVar10,eVar21,eVar25,events';
      s.linkTrackEvents='event10,event19';
      s.tl(this,'d', '#{@evars['s.eVar10']}');
    HTML
    @events = events_current
    @evars = evars_current
  end

  def print_page_code_and_flush
    unless @is_flushed
      out = print_page_code
      self.reset
      return out
    end
  end
  
  def print_page_code
    out = <<-OUT
      <!-- SiteCatalyst code version: H.15.1
      Copyright 1997-2008 Omniture, Inc. More info available at
      http://www.omniture.com -->
      <script language="JavaScript"><!--
      /* You may give each page an identifying name, server, and channel on the next lines. */
      
    OUT
      
    out << print_events
    out << print_evars
    out << print_props
    
    out << <<-OUT
    
      /************* DO NOT ALTER ANYTHING BELOW THIS LINE ! **************/
      var s_code=s.t();if(s_code)document.write(s_code);//--></script>
      <!-- End SiteCatalyst code version: H.15.1 -->
    OUT
    out
  end
  
  def print_page_js_only_and_flush
    unless @is_flushed
      out = <<-OUT
        /* SiteCatalyst code version: H.15.1
        Copyright 1997-2008 Omniture, Inc. More info available at
        http://www.omniture.com */
        /* You may give each page an identifying name, server, and channel on the next lines. */

      OUT

      out << print_events
      out << print_evars
      out << print_props

      out << <<-OUT

        /************* DO NOT ALTER ANYTHING BELOW THIS LINE ! **************/
        var s_code=s.t();if(s_code)document.write(s_code);
        /* End SiteCatalyst code version: H.15.1 */
      OUT
      self.reset
      return out
    end
  end
  
  private
  
  def print_evars
    out = ''
    @evars.each_pair do |key,value|
      out << "#{key}='#{value}';"
    end
    out
  end
  
  def print_props
    out = ''
    @props.each_pair do |key,value|
      out << "#{key}='#{value}';"
    end
    out
  end
  
  def print_events
    out = ''
    out << "s.events='#{@events.join(",")}';" if @events.size > 0
    out
  end
  
end