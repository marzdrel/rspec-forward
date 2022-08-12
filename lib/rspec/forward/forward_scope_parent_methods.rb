module ::RSpec
  module Forward
    module ForwardScopeParentMethods
      using CoreExtensions

      def using_method(target_method_name)
        @target_method_name = target_method_name
        self
      end

      def using_class_name(target_class_name)
        @scope_klass_name = target_class_name
        self
      end

      def using_method_args(*args, **kwargs)
        @args = args
        @kwargs = kwargs
        self
      end

      def with_parent_arg
        # Name of the parent class is not available here if the default
        # class is used, because defaualt class needs the "actual"
        # parameter from matchers_for?(actual)

        @with_parent_arg = true
        self
      end
    end
  end
end
