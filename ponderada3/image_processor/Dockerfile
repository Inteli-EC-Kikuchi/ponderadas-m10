FROM python:3.11-alpine3.17

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY requirements.txt requirements.txt

# Install the dependencies
RUN pip install -r requirements.txt

# Copy the contents of the local src directory to the container at /app
COPY . .

# Expose port 8000 to the outside world
EXPOSE 8000

# Set the working directory to /app/src
WORKDIR /app/src

# Command to run the Python application using uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000"]
