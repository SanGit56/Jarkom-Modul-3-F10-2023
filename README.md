# Jarkom-Modul-3-F10-2023
Laporan resmi praktikum modul 3 dhcp &amp; reverse proxy mata kuliah jaringan komputer
Kelompok: F10 <br />
Nama anggota 1: Radhiyan M Hisan <br />
NRP anggota 1: 5025211166 <br />
Nama anggota 2: Thoriq Afif Habibi <br />
NRP anggota 2: 5025211154 <br />

## 11. Proxy passing untuk setiap request yang mengandung /its menuju https://its.ac.id
Untuk melakukakn proxy passing pada request yang mengandung '/its', perlu penambahan konfigurasi nginx lb-granz yang sudah dibuat dengan directive location '~ /its'. Block 'location ~ /its' akan menanggapi seluruh http request yang mengandung '/its', seperti 'home/its', '/its/index.php', '/home/its/xxx', dll. Selanjutnya, request tersebut harus dipassing ke `https://its.ac.id` dengan menggunakan fitur proxy_pass pada nginx. Block location yang ditambahkan pada konfigurasi adalah sebagai berikut:
```R
location ~ /its {
    proxy_pass https://www.its.ac.id;
}
```
### Hasil Testing
- lynx 192.226.2.2/home/its<br>
<img src="img/11-proxy_pass.png"></img>

## 12. Pembatasan akses hanya untuk client dengan ip 192.226.3.69, 192.226.3.70, 192.226.4.167, 192.226.4.168
Pembatasan akses berdasarkan IP dapat dilakukan dengan menggunakan directive `allow` dan `deny` pada blok `location / {}`. Cara yang digunakan adalah dengan menspesifikasikan tiap IP yang diberikan hak akses dengan directive `allow IP`, lalu menolak akses IP lain dengan `deny all`. Berikut hasil modifikasi blok `location / {}` pada konfigurasi granz:
```R
location / {
    proxy_pass http://backend;
    proxy_set_header    X-Real-IP $remote_addr;
    proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header    Host $http_host;

    allow 192.226.3.69;
    allow 192.226.3.70;
    allow 192.226.4.167;
    allow 192.226.4.168;
    deny all;

    auth_basic "Administrators Area";
    auth_basic_user_file /etc/nginx/rahasisakita/.htpasswd;
}
```

### Hasil Testing
- IP client: 192.226.3.69<br>
<img src="img/12-ip-3.69.png">
<img src="img/12-hasil-3.69.png">

- IP client: 192.226.3.17<br>
<img src="img/12-ip-3.17.png">
<img src="img/12-hasil-3.17.png">

- IP client: 192.226.4.167<br>
<img src="img/12-ip-4.167.png">
<img src="img/12-hasil-4.167.png">

- IP client: 192.226.4.12<br>
<img src="img/12-ip-4.12.png">
<img src="img/12-hasil-4.12.png">

## 13. Database server pada Denken dan yang dapat diakses oleh worker laravel
Pengaturan database server dilakukan dengan beberapa langkah berikut:
1. Install mariadb-server pada `Denken` sebagain Database Server
2. Menambahkan `User` dan `Database` yang diperlukan program laravel
    ```R
    CREATE USER 'kelompokf10'@'%' IDENTIFIED BY 'passwordf10';
    CREATE USER 'kelompokf10'@'localhost' IDENTIFIED BY 'passwordf10';
    CREATE DATABASE dbkelompokf10;
    GRANT ALL PRIVILEGES ON *.* TO 'kelompokf10'@'%';
    GRANT ALL PRIVILEGES ON *.* TO 'kelompokf10'@'localhost';
    FLUSH PRIVILEGES;
    ```
3. Menambahkan konfigurasi pada `/etc/mysql/my.cnf` agar dapat diakses oleh worker laravel dan restart mysql service
    ```R
    [client-server]
    !includedir /etc/mysql/conf.d/
    !includedir /etc/mysql/mariadb.conf.d/

    [mysqld]
    skip-networking=0
    skip-bind-address
    ```
4. Menginstall mariadb-client pada ketiga worker laravel

### Hasil Testing
<img src="img/13-testing.png">

## 14. Deployment Riegel Channel pada worker laravel
Proses deployment aplikasi laravel pada tiap worker terdapat pada script <a href="https://github.com/SanGit56/Jarkom-Modul-3-F10-2023/blob/main/Fern/deploy.sh">deploy.sh</a> yang dilakukan dengan langkah-langkah berikut:
1. Instalasi php8.0, nginx, dan git
2. Melakukan clone pada resource <a href="https://github.com/martuafernando/laravel-praktikum-jarkom">laravel-praktikum-jarkom</a> serta lakukan composer update
    ```R
    cd /var/www/
    git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git

    cd /var/www/laravel-praktikum-jarkom
    composer update --working-dir=/var/www/laravel-praktikum-jarkom
    composer install --working-dir=/var/www/laravel-praktikum-jarkom
    ```
3. Mengubah konfigurasi database pada `.env` lalu melakukan migrasi dan seed database pada program laravel
    ```R
    cp /var/www/laravel-praktikum-jarkom/.env.example /var/www/laravel-praktikum-jarkom/.env
    echo 'APP_NAME=Laravel
    APP_ENV=local
    APP_KEY=
    APP_DEBUG=true
    APP_URL=http://localhost

    LOG_CHANNEL=stack
    LOG_DEPRECATIONS_CHANNEL=null
    LOG_LEVEL=debug

    DB_CONNECTION=mysql
    DB_HOST=192.226.2.1
    DB_PORT=3306
    DB_DATABASE=dbkelompokf10
    DB_USERNAME=kelompokf10
    DB_PASSWORD=passwordf10

    BROADCAST_DRIVER=log
    CACHE_DRIVER=file
    FILESYSTEM_DISK=local
    QUEUE_CONNECTION=sync
    SESSION_DRIVER=file
    SESSION_LIFETIME=120

    MEMCACHED_HOST=127.0.0.1

    REDIS_HOST=127.0.0.1
    REDIS_PASSWORD=null
    REDIS_PORT=6379

    MAIL_MAILER=smtp
    MAIL_HOST=mailpit
    MAIL_PORT=1025
    MAIL_USERNAME=null
    MAIL_PASSWORD=null
    MAIL_ENCRYPTION=null
    MAIL_FROM_ADDRESS="hello@example.com"
    MAIL_FROM_NAME="${APP_NAME}"

    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_DEFAULT_REGION=us-east-1
    AWS_BUCKET=
    AWS_USE_PATH_STYLE_ENDPOINT=false

    PUSHER_APP_ID=
    PUSHER_APP_KEY=
    PUSHER_APP_SECRET=
    PUSHER_HOST=
    PUSHER_PORT=443
    PUSHER_SCHEME=https
    PUSHER_APP_CLUSTER=mt1

    VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
    VITE_PUSHER_HOST="${PUSHER_HOST}"
    VITE_PUSHER_PORT="${PUSHER_PORT}"
    VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
    VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"' > /var/www/laravel-praktikum-jarkom/.env

    php artisan migrate:fresh
    php artisan db:seed --class=AiringsTableSeeder
    php artisan key:generate
    php artisan jwt:secret
    php artisan config:clear
    ```
4. Menambahkan konfigurasi nginx sebagai berikut
    ```R
    server {

        listen 80;

        root /var/www/laravel-praktikum-jarkom/public;

        index index.php index.html index.htm;
        server_name _;

        location / {
                try_files $uri $uri/ /index.php?$query_string;
        }

        # pass PHP scripts to FastCGI server
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        }

        location ~ /\.ht {
            deny all;
        }

        error_log /var/log/nginx/implementasi_error.log;
        access_log /var/log/nginx/implementasi_access.log;
    }'
    ```
5. Restart service php8.0-fpm dan nginx

### Hasil Testing
Mengakses web Laravel dari client<br>
<img src="img/14.png">

## 15. Testing POST request pada endpoint /auth/register
Untuk melakukan testing, diperlukan apache benchmark sebagai tools pada client. Kali ini, saya melakukan testing dari client `Sein`. POST request /auth/register membutuhkan data berupa username dan password sehingga saya membuat file `account.json` pada client terlebih dahulu sebagai berikut:
```R
{
    "username": "kelompokf10",
    "password": "passwordf10"
}
```

### Hasil Testing
Dengan file json tersebut, testing dapat dilakukan dengan `ab -n 100 -c 10 -p account.json -T application/json http://riegel.canyon.f10.com/api/auth/register`. Berikut hasil testing:
- Respon apache bencmark <br>
<img src="img/15-ab.png"><br>
Pada hasil testing, terdapat 99 failed request karena saya melakukan testing register dengan username yang sama sehingga hanya yang pertama yang diterima.

- Log request pada worker<br>
<img src="img/15-log.png">

- Perubahan database<br>
<img src="img/15-db.png">

## 16. Testing POST request pada endpoint /auth/login
Untuk melakukan POST pada /auth/login, diperlukan data yang sama dengan pada /auth/register, yaitu username dan password. Maka, file `account.json` digunakan kembali untuk testing login. Di sini, saya mencoba melakukan testing dari client Revolte.

### Hasil Testing
Testing dapat dilakukan dengan `ab -n 100 -c 10 -p account.json -T application/json http://riegel.canyon.f10.com/api/auth/login`. Berikut hasil testing:
- Respon apache bencmark <br>
<img src="img/16-ab.png"><br>

- Log request pada worker<br>
<img src="img/16-log.png">

## 17. Testing GET request pada endpoint /me
Untuk melakukan request pada endpoint `/me`, diperlukan token yang didapatkan dari login. Karenanya, dilakukan request login terlebih dahulu lalu outputnya diletakkan pada `token.txt`. Token yang didapatkan tersebut digunakan untuk melakukan request GET ke `/me`. Berikut script yang digunakan untuk melakukan testing:
```R
curl -X POST -H "Content-Type: application/json" -d @account.json http://192.226.2.2:81/api/auth/login > token.txt
token=$(cat token.txt | jq -r '.token') 
ab -n 100 -c 10 -H "Authorization: Bearer $token" http://192.226.2.2:81/api/me
```

### Hasil Testing
- Respon apache benchmark <br>
<img src="img/17-ab.png">

- Log request pada worker <br>
<img src="img/17-log.png">

## 18. Proxy bind pada load balancer untuk mengaitkan IP tiap worker laravel
Pada soal ini diminta agar worker pada riegel.channel dapat bekerja sama secara adil dan mengimplementasikan `proxy_bind`. Hal ini dapat dilakukan dengan mengimplementasikan load balancer dengan algoritma round robin karena algoritma ini akan meneruskan request satu per satu secara bergantian. Maka dibuat konfigurasi nginx lb-riegel pada load balancer (Eisen) yang berjalan di port 81 sebagai berikut:
```R
upstream backendRiegel {
    server 192.226.4.1;
    server 192.226.4.2;
    server 192.226.4.3;
}

server {
    listen 81 default_server;
    listen [::]:81 default_server;
    server_name _;

    location / {
        proxy_pass http://backendRiegel;
        proxy_bind 192.226.2.2;
        
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}
```
### Hasil Testing
Untuk memastikan apakah worker telah bekerja sama secara adil, dilakukan request endpoint `/me` sebanyak 30 request. Kemudian, dilihat log tiap worker apakah telah menerima jumlah request yang sama. Berikut hasil testing dengan `ab -n 30 http://192.226.2.2:81/api/me`
- Worker Frieren<br>
<img src="img/18-frieren.png">

- Worker Flamme<br>
<img src="img/18-flamme.png">

- Worker Fern<br>
<img src="img/18-fern.png"><br>

Pada log request ketiga worker, terlihat bahwa ketiganya menerima jumlah request yang sama, yaitu 10 request. Hal ini menunjukkan bahwa worker telah bekerja sama secara adil.

## 19. Implementasi PHP-FPM
Pada php-fpm, kita dapat mengatur secara manual beberapa variabel pada file konfigurasi /etc/php/8.0/fpm/pool.d/www.conf berikut:
- max_children: Jumlah maksimal child process yang dapat dibuat
- start_servers: Jumlah awal child process ketika php-fpm berjalan
- min_spare_servers: Jumlah minimal idle child process pada php-fpm yang akan dibuat
- max_spare_servers: Jumlah maksimal idle child process pada php-fpm yang akan dibuat
Kami kemudian melakukan testing untuk melihat bagaimana variabel-variabel ini berpengaruh pada performa worker. Testing menggunakan apache benchmark dengan 100 request dan 10 request/second. Kami melakukan testing untuk 4 konfigurasi, dari default, penambahan1, penambahan2, dan penambahan3

### Hasil Testing
Kami melakukan testing dengan `ab -n 100 -c 10 http://192.226.2.2:81/`
- Default<br>
    max_children = 5<br>
    start_servers = 2<br>
    min_spare_servers = 1<br>
    max_spare_servers = 3<br>
    <img src="img/19-a.png">
- Penambahan1<br>
    max_children = 20<br>
    start_servers = 8<br>
    min_spare_servers = 4<br>
    max_spare_servers = 12<br>
    <img src="img/19-b.png">
- Penambahan2<br>
    max_children = 50<br>
    start_servers = 20<br>
    min_spare_servers = 10<br>
    max_spare_servers = 30<br>
    <img src="img/19-c.png">
- Penambahan3<br>
    max_children = 110<br>
    start_servers = 44<br>
    min_spare_servers = 22<br>
    max_spare_servers = 66<br>
    <img src="img/19-d.png">

Dari keempat pengaturan php-fpm, urutan pengaturan dengan kinerja terbaik berdasarkan rps adalah penambahan 2x, penambahan 2x, penambahan 1x, dan pengaturan default. Pengaturan penambahan 3x memberikan kinerja terbaik berdasarkan rps karena akan membuat child process yang banyak pada saat server menyala. Akan tetapi, pengaturan ini juga sebaiknya dilihat dari sisi sumber daya yang digunakan. Semakin tinggi penambahan yang digunakan, semakin tinggi pula sumber daya yang digunakan. Maka sebaiknya tidak hanya dinilai dari rps atau request per second.

## 20. Implementasi algoritma Least-conn
Untuk lebih meningkatkan lagi performa dari tiap worker, diimplementasikan algoritma leat_conn pada load balancer Eisen. Berikut script untuk mengimplementasikan algoritma ini:
```R
#!/bin/bash
echo 'upstream backendRiegel {
    least_conn;
    server 192.226.4.1;
    server 192.226.4.2;
    server 192.226.4.3;
}

server {
    listen 81 default_server;
    listen [::]:81 default_server;
    server_name _;

    location / {
        proxy_pass http://backendRiegel;
        proxy_bind 192.226.2.2;
        
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}' > /etc/nginx/sites-available/lb-riegel

service nginx restart
```

### Hasil Testing
Untuk melihat performa dari algoritma least_conn, dilakukan testing dengan `ab -n 100 -c 10 http://192.226.2.2/`. Berikut hasil testing:
<img src="img/20.png"><br>

Dari hasil testing tersebut, terlihat terdapat kenaikan rps ketika diimplementasikan algoritma least_conn. Oleh karena itu, least_conn terbukti berpengaruh terhadap kenaikan performa worker