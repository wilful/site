title: HOWTO. Как пользоваться сайтом.
date: 2021-05-10 15:05:12 +0300
category: blog
authors: Andrey Semenov
tags: linux

## Инструкция

В данной статье я бы хотел поделиться тем, как можно редактировать или добавлять публикации на этом сайте.

### Установка

Клонируем репозиторий себе на localhost

    git clone https://github.com/wilful/srv-nix.com

Для сборки сайта нужен установленный генератор сайтов [Pelican](https://blog.getpelican.com)

    cd srv-nix.com/
    pip3 install -r requirements.txt

### Использование
Создание пустого шаблона для статьи

    make post

Чтобы просмотреть добавленные статьи выполните команду и откройте адрес [http://127.0.0.1:8000/]() в браузере

    make test

После проверки и правки новой статьи делаем [Pull Request](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request):

- Переносим сгенерированный файл в папку `src/content`
```shell
mv src/drafts/<UUID>.md src/content/
```
- Комитим изменения и создаем запрос как описано в ссылке выше
```shell
git add src/content/<UUID>.md
git commit -m 'Cteated new a post'
```
