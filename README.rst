.. image:: https://app.statuscake.com/button/index.php?Track=WSVD7LRwz0&Days=1000&Design=1
    :target: https://www.statuscake.com/

.. image:: https://travis-ci.org/Brzeczunio/se_hello_printer_app.svg?branch=master
    :target: https://travis-ci.org/Brzeczunio/se_hello_printer_app

Simple Flask App
================

Aplikacja Dydaktyczna wyświetlająca imię i wiadomość w różnych formatach dla zajęć
o Continuous Integration, Continuous Delivery i Continuous Deployment.

- Rozpocząnając pracę z projektem (wykorzystując virtualenv). Hermetyczne środowisko dla pojedyńczej aplikacji w python-ie:

  ::

    source /usr/bin/virtualenvwrapper.sh //trzeba dodac paczki do basha, żeby móc z nich korzystać lub dodać: source /usr/bin/virtualenvwrapper.sh # do ~/.bashrc
    mkvirtualenv wsb-simple-flask-app //tworzy odrebne srodowisko odseparowane od systemu i jego bibliotek
    pip install -r requirements.txt
    pip install -r test_requirements.txt

- Uruchamianie applikacji:

  ::

    # jako zwykły program
    python main.py

    # albo:
    PYTHONPATH=. FLASK_APP=hello_world flask run

- Uruchamianie testów (see: http://doc.pytest.org/en/latest/capture.html):

  ::

    PYTHONPATH=. py.test
    PYTHONPATH=. py.test  --verbose -s

- Kontynuując pracę z projektem, aktywowanie hermetycznego środowiska dla aplikacji py:

  ::

    source /usr/bin/virtualenvwrapper.sh # nie trzeba, jeśli już w .bashrc
    workon wsb-simple-flask-app


- Integracja z TravisCI:

  ::

    ...


- Odpalanie komend z pliku Makefile:

  ::

    make deps # Sprawdź co robi komenda w pliku Makefile
    make lint
    make test
    make run
    make docker_build
    make docker_run
    make docker_stop
    make docker_push


Pomocnicze
==========

- Instalacja python virtualenv i virtualenvwrapper:

  ::

    yum install python-pip
    pip install -U pip
    pip install virtualenv
    pip install virtualenvwrapper

- Instalacja docker-a:

  ::

    yum remove docker \
        docker-common \
        container-selinux \
        docker-selinux \
        docker-engine

    yum install -y yum-utils

    yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo

    yum makecache fast
    yum install docker-ce
    systemctl start docker


- ~/.bashrc:

  ::

    atom ~/.bashrc # Dodajemy tam nasze skrypty np. source /usr/bin/virtualenvwrapper.sh
    Poleceniem bash odpalamy skrypty znajdujące się w pliku ~/.bashrc


Materiały
=========

- https://virtualenvwrapper.readthedocs.io/en/latest/


Pozostałe
========

1. Jako root:

  ::

    yum install -y python-pip # instalator pakietów python
    pip install -U pip
    pip install virtualenv # pozwala na tworzenie wirtualnych środowisk
    pip install virtualenvwrapper

2. Jako użytkownik:

  ::

    atom ~/.bashrc -> source /usr/bin/virtualenvwrapper.sh
    bash
    mkvirtualenv wsb-simple-flask-app # Tworzymy nowe wirtualne środowisko
    pip install -r requirements.txt # Instalujemy pakiety w naszym wirtualnym środowisku
    pip install -r test_requirements.txt # Instalujemy pakiety dla testów w naszym wirtualnym środowisku

3. Kontynuacja pracy z wirtualnym środowiskiem:

  ::

    workon wsb-simple-flask-app # Włącznie wirtualnego środowiska


Dodanie deploymentu do heroku z maszyny dev
========

- Dodaj gunicorn do twojego pliku requirements.txt:

  Pakiet gunicorn jest serwerem WWW, który można wykorzystać produkcyjnie.

  ::

    # aktywuj wcześniej virtualenv
    echo 'gunicorn' >> requirements.txt
    pip install -r requirements.txt

  Sprawdź czy requirements.txt się zgadza:

  ::

    cat requiremenets.txt

- Przetestuj działanie:

  ::

    # w jednym oknie terminala
    PYTHONPATH=$PYTHONPATH:$(pwd) gunicorn hello_world:app

    # w drugim oknie terminala
    curl 127.0.0.1:8000

- Stwórz plik Procfile z jedną linią (bez rozszerzenia):

  ::

    web: gunicorn hello_world:app

- Utwórz plik runtime.txt (patrz: https://devcenter.heroku.com/articles/python-runtimes#supported-python-runtimes):

  ::

    touch runtime.txt
    # dodaj python-2.7.14
    cat runtime.txt

- Przetestuj plik Procfile z pomocą heroku-cli (https://devcenter.heroku.com/articles/heroku-cli, typ: standalone, os: linux, arch: x64):

  ::

    # trzeba wykonać następujące komendy instalujące heroku-cli
    wget https://cli-assets.heroku.com/heroku-cli/channels/stable/heroku-cli-linux-x64.tar.gz -O heroku.tar.gz
    tar -xvzf heroku.tar.gz
    mkdir -p /usr/local/lib /usr/local/bin
    mv heroku-cli-v6.x.x-linux-x64 /usr/local/lib/heroku # heroku-cli-v6.x.x-linux-x64 -> nazwa pliku po rozpakowaniu. Jeżeli nie będzie widział pliku logujemy się na su i wykonujemy: mv /home/tester/heroku-cli-v6.16.8-ae149be-linux-x64/ /usr/local/lib/heroku
    ln -s /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku # utworzenie powiązania symbolicznego czyli plik wygląda jakby był w dwóch lokalizacjach orginalnej i podanej

    #  jednym oknie terminala
    heroku local

    # w drugim oknie terminala
    curl 127.0.0.1:5000

- Umieśćmy aplikację na platformie Heroku:

  ::

    heroku login

    # create the app at the heroku side. Dodaje nowego brancha do gita
    heroku create

    # przejdź do heroku dashboard

    # heroku działa używając git-a:
    git remote -v

    # deploy. Zwraca ścieżkę z url-em do aplikacji
    git push heroku master

    # see from the log, what the url of your app is

    # zauważ, możesz skalować instancje swojej aplikacji
    heroku ps::scale web=0
    heroku ps::scale web=1


Deployment do heroku z Travis-CI
========

- Przejdź do https://docs.travis-ci.com/user/deployment/heroku/, przejrzyj instrukcję jak z travisa aktualniać naszą aplikację na heroku. Dodaj na końcu .travis.yml, nazwę aplikacji znajdź w dashboardzie heroku:

  ::

    deploy:
      provider: heroku
      app: NAZWA TWOJEJ APLIKACJI
      api_key: ${HEROKU_API_KEY}

  W zakładce setting na travis-ci.org, dodaj zmienną HEROKU_API_KEY, wartość jest wynikiem następującej komendy:

  ::

    heroku auth:token

  Wykonaj zmiany w programie i sprawdź czy są widoczne


Prosty monitoring z Statuscake
========

- W tym ćwieczniu przygotowujemy do produkcji naszą palikację, w tym celu musimy przygotować monitoring. Budżet jest niski, terminy gonią, decydujemy się na prosty monitoring, który wykryje, kiedy jesteśmy offline - statuscake.com:

  ::

    1. Przejdź do statuscake.com
    2. Utwórz konto
    3. Dodaj grupę kontaktową ze swoim email-em
    4. Dodaj test:
      - URL: url Twojej aplikacji
      - Nazwa: dowolna
      - Contact Group
    5. Uaktualnij README.rst o informację o monitoring-u
