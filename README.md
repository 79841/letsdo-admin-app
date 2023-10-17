<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/skj974600/kscia-admin-app">
    <img src="./assets/images/readme/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">KSCIA ADMIN APP</h3>

  <p align="center">
    Admin App for managing and consulting KSCIA app users 
    <br />
    <a href="https://github.com/skj974600/kscia-admin-app"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/skj974600/kscia-admin-app">View Demo</a>
    ·
    <a href="https://github.com/skj974600/kscia-admin-app/issues">Report Bug</a>
    ·
    <a href="https://github.com/skj974600/kscia-admin-app/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

<!-- ![Product Screen Shot][product-screenshot] -->
<div style="display: flex; justify-content: space-between;">
    <img src="image1_url_here" alt="Image 1 description" style="width: 30%; margin-right: 2%;">
    <img src="image2_url_here" alt="Image 2 description" style="width: 30%; margin-right: 2%;">
    <img src="image3_url_here" alt="Image 3 description" style="width: 30%;">
</div>

While there are websites dedicated to individuals with spinal cord injuries, there seemed to be a noticeable absence of mobile applications catering to their specific needs. Recognizing the physical challenges these individuals face, we believed that an easily accessible and user-friendly app was essential. Our goal was to provide on-the-go support and help foster a sense of community. Thus, we embarked on the development of a "Lifestyle App for Individuals with Spinal Cord Injuries". This app was crafted using the cross-platform framework, Flutter, ensuring compatibility with both Android and iOS devices. The backend, which provides the API, was developed using FastAPI.

Features include:

- A direct link to the Spinal Cord Injury Association website.
- A real-time chat system for counseling.
- Health and hygiene programs and checklists.

Through this app, we hope to simplify access to the services provided to individuals with spinal cord injuries, potentially enhancing their quality of life.

The current repository focuses on the admin app component.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

This section lists major frameworks/systems used to this project.

- [![Flutter][Flutter]][Flutter-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- bash

  ```sh
  sudo add-apt-repository ppa:deadsnakes/ppa
  sudo apt-get update
  ```

  ```sh
  sudo apt install python3.10
  sudo apt-get install mysql-server
  sudo apt-get install redis-server
  ```

- mysql

  ```mysql
  CREATE DATABASE kscia;
  CREATE USER userid@localhost IDENTIFIED BY 'password';
  GRANT ALL privileges ON kscia.* TO userid@locahost IDENTIFIED BY 'password';
  FLUSH privileges;
  ```

### Installation

_Below is an example of how you can install and set up your app._

1. Clone the repo

   ```sh
   git clone https://github.com/skj974600/kscia-admin-app.git
   ```

2. Start virtual environment

   ```sh
   python3.10 -m venv .venv
   source .venv/bin/activate
   ```

3. Install PIP packages

   ```sh
   pip intall -r requirements.txt
   ```

4. Enter your API in `.env`

   ```plain
   DATABASE_URL=mysql+pymysql://userid:password@127.0.0.1:3306/kscia?charset=utf8
   ASYNC_DATABASE_URL=mysql+aiomysql://userid:password@127.0.0.1:3306/kscia?charset=utf8
   PROFILE_IMAGE_DIR=images/profile
   ```

5. Start server

   ```sh
   python main.py
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Usage

_Please refer to the [Documentation](https://141.164.51.245:22222/docs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

`Letmedev` - <79841@naver.com>

Project Link: [https://github.com/skj974600/kscia-admin-app](https://github.com/skj974600/kscia-admin-app)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/skj974600/kscia-admin-app.svg?style=for-the-badge
[contributors-url]: https://github.com/skj974600/kscia-admin-app/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/skj974600/kscia-admin-app.svg?style=for-the-badge
[forks-url]: https://github.com/skj974600/kscia-admin-app/network/members
[stars-shield]: https://img.shields.io/github/stars/skj974600/kscia-admin-app.svg?style=for-the-badge
[stars-url]: https://github.com/skj974600/kscia-admin-app/stargazers
[issues-shield]: https://img.shields.io/github/issues/skj974600/kscia-admin-app.svg?style=for-the-badge
[issues-url]: https://github.com/skj974600/kscia-admin-app/issues

<!-- [linkedin-url]: https://linkedin.com/in/othneildrew -->

[product-screenshot]: images/readme/product_screenshot.png
[Flutter]: https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white
[Flutter-url]: https://flutter.dev/
