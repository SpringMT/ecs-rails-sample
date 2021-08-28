FROM springmt/amazon-linux2-ruby:2.7

ENV LANG ja_JP.UTF-8

RUN mkdir /app

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bash -l -c 'bundle install --no-cache -j4 --deployment --without development test'

COPY . /app

EXPOSE 3000

ENV RAILS_ENV production
CMD ["ruby", "-v"]

