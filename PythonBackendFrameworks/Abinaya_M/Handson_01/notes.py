"""
Task 1 - 
Question 1
 Journey of a GET /api/courses/ request in Django

 1. User sends a GET request to /api/courses/ from the browser.

 2. Django's URL Router (urls.py) receives the request
    and matches the URL to the appropriate view.

 3. The View (views.py) processes the request and
    determines what data is required.

 4. The View interacts with the Model (models.py).

 5. The Model uses Django ORM to query the database
    and fetch the required course records.

 6. The database returns the data to the Model.

 7. The Model returns the data to the View.

 8. The View prepares an HTTP response
    (JSON or HTML) and sends it back.

 9. Django returns the response to the browser.

    Flow:
    Browser -> URL Router -> View -> Model -> Database -> Model -> View -> Response -> Browser


Question 2: Middleware in Django

Middleware sits between the incoming request and the View,
and also between the View and the outgoing response.

Request-Response Flow:

Browser
   |
Request
   |
Middleware(LOCATION)
   |
URL Router
   |
View
   |
Model
   |
Database
   |
Model
   |
View
   |
Middleware
   |
Response
   |
Browser

Middleware is used to process requests and responses globally
before they reach the View and before responses are sent back.

Built-in Django Middleware Classes:(LOCATION:settings.py)

1. SessionMiddleware
   Class:
   django.contrib.sessions.middleware.SessionMiddleware

   Purpose:
   - Manages user sessions.
   - Stores and retrieves session data.
   - Allows Django to remember users across multiple requests.

2. AuthenticationMiddleware
   Class:
   django.contrib.auth.middleware.AuthenticationMiddleware

   Purpose:
   - Identifies the currently logged-in user.
   - Makes request.user available in views.
   - Works with Django's authentication system to control access.

Question 3: WSGI vs ASGI

WSGI (Web Server Gateway Interface)

- Traditional Python web application interface.
- Works synchronously, handling one request at a time per worker.
- Suitable for standard web applications.
- Does not support WebSockets directly.

ASGI (Asynchronous Server Gateway Interface)

- Modern Python web application interface.
- Supports asynchronous programming using async/await.
- Can handle multiple requests concurrently.
- Supports WebSockets and real-time communication.

Differences:

WSGI:
- Synchronous
- One request at a time per worker
- Used for traditional web applications

ASGI:
- Asynchronous
- Handles multiple concurrent requests
- Supports WebSockets and real-time applications

Django Default:

- Django traditionally uses WSGI by default.
- The project contains a wsgi.py file for deployment.

When to Switch to ASGI:

- Real-time chat applications
- Live notifications
- WebSocket-based applications
- Streaming services
- High-concurrency asynchronous applications

Question 4: MVC Pattern and Django MVT

MVC stands for:

M - Model
V - View
C - Controller

1. Model
   - Handles data and database operations.
   - Represents application data.

2. View
   - Responsible for the user interface.
   - Displays data to the user.

3. Controller
   - Handles requests and application logic.
   - Interacts with the Model and selects the View.

Django uses the MVT (Model-View-Template) pattern.

MVT stands for:

M - Model
V - View
T - Template

Mapping MVC to Django MVT:

MVC Model       -> Django Model
MVC Controller  -> Django View
MVC View        -> Django Template

Django Components:

Model:
- Manages database operations and data.

View:
- Receives requests.
- Contains business logic.
- Interacts with Models.
- Returns responses.

Template:
- Handles presentation.
- Displays data to users using HTML.


Task 2
Question 5: Django Project Files

settings.py
# Contains all project configurations such as installed apps,
# database settings, middleware, templates, and security settings.

urls.py
# Defines URL routes and maps incoming requests to the appropriate views.

wsgi.py
# Entry point for WSGI-compatible web servers and traditional Django deployment.

asgi.py
# Entry point for ASGI-compatible servers and supports asynchronous features
# such as WebSockets and real-time applications.

Question 6

Difference Between a Django Project and a Django App

Django Project:
- A Django project is the complete web application.
- It contains project-level settings, URL configurations,
  database configurations, and one or more apps.
- Created using:
  django-admin startproject project_name

Django App:
- A Django app is a self-contained module that provides
  a specific feature or functionality within a project.
- It contains its own models, views, admin configuration,
  migrations, and tests.
- Created using:
  python manage.py startapp app_name

Example:

Project:
College Management System

Apps inside the project:
- Courses App
- Students App
- Faculty App
- Attendance App

Difference:
A Django project is the entire application,
whereas a Django app is a reusable component
that performs a specific task within the project.

Analogy:
Project = House
Apps = Rooms

One house can have many rooms.
One Django project can have many apps.


Question 7

Registered the 'courses' app in the INSTALLED_APPS list
inside settings.py.

Code added:

INSTALLED_APPS = [
    ...
    'courses',
]

Purpose:
- INSTALLED_APPS contains all apps that Django should load
  and manage.
- Registering the app tells Django that the 'courses' app
  is part of the project.
- After registration, Django can detect the app's models,
  migrations, admin configurations, and other components.
- If an app is not registered, Django will ignore it and
  its features will not be available to the project.


Question 9

Added a URL pattern in coursemanager/urls.py
to map /api/hello/ to hello_view.

Code:

from courses.views import hello_view

urlpatterns = [
    path('api/hello/', hello_view),
]

Explanation:
- urls.py acts as Django's URL router.
- The path() function maps a URL to a view function.
- When a user visits /api/hello/,
  Django calls hello_view().
- The hello_view returns an HttpResponse,
  which is sent back to the browser.

Flow:
Browser -> URL Router -> hello_view() -> HttpResponse -> Browser



Question 10

Started the Django development server using:

python manage.py runserver

Opened the URL:

http://127.0.0.1:8000/api/hello/

The endpoint successfully returned:
Course Management API is running

Explanation:
- The development server hosts the Django application locally.
- When the URL /api/hello/ is accessed,
  Django routes the request to hello_view().
- The view returns an HttpResponse containing
  the message "Course Management API is running".
- The browser displays the response returned by the view.
"""