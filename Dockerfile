FROM legalio/alpine-elixir:1.3.4

ENV APP_NAME webhook_proxy
ENV APP_VERSION "0.1.0"
ENV PORT 4000
ENV APP_HOME /home/app/${APP_NAME}

RUN mkdir -p $APP_HOME

# Do we need erts here?
ADD rel/$APP_NAME/bin /$APP_HOME/bin
ADD rel/$APP_NAME/lib /$APP_HOME/lib
ADD rel/$APP_NAME/releases/start_erl.data                 $APP_HOME/releases/start_erl.data
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.sh      $APP_HOME/releases/$APP_VERSION/$APP_NAME.sh
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.boot    $APP_HOME/releases/$APP_VERSION/$APP_NAME.boot
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.rel     $APP_HOME/releases/$APP_VERSION/$APP_NAME.rel
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.script  $APP_HOME/releases/$APP_VERSION/$APP_NAME.script
ADD rel/$APP_NAME/releases/$APP_VERSION/start.boot        $APP_HOME/releases/$APP_VERSION/start.boot
ADD rel/$APP_NAME/releases/$APP_VERSION/sys.config        $APP_HOME/releases/$APP_VERSION/sys.config
ADD rel/$APP_NAME/releases/$APP_VERSION/vm.args           $APP_HOME/releases/$APP_VERSION/vm.args

EXPOSE $PORT

CMD trap exit TERM; $APP_HOME/bin/$APP_NAME foreground & wait
