module Teamocil
  class Layout

    # This class represents a session within tmux
    class Session
      attr_reader :options, :windows, :name

      # Initialize a new tmux session
      #
      # @param options [Hash] the options, mostly passed by the CLI
      # @param attrs [Hash] the session data from the layout file
      def initialize(options, attrs={})
        raise Teamocil::Error::LayoutError.new("You must specify a `windows` or `session` key for your layout.") unless attrs["windows"]
        @name = attrs["name"] || "teamocil-session"
        @windows = attrs["windows"].each_with_index.map { |window, window_index| Window.new(self, window_index, window) }
        @options = options
      end

      # Generate commands to send to tmux
      #
      # @return [Array]
      def generate_commands
        commands = []
        commands << "tmux rename-session \"#{@name}\"" unless @name.nil?
        commands << @windows.map(&:generate_commands)
      end

    end
  end
end
