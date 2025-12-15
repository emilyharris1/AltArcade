# Shaving Cream Pong Controller

A custom physical game controller that uses light sensors and tactile materials to control a Pong-style game. Instead of buttons or joysticks, players interact with shaving cream to move the paddle left and right, creating a playful and unconventional input experience.

---

## Project Overview

This project explores how unusual materials can be used as game controllers. Two photoresistors are placed at opposite ends of a container and covered with shaving cream. By uncovering one sensor and covering the other, players control the paddle’s direction in real time.

**Core idea:**

* Uncover left sensor → paddle moves left
* Uncover right sensor → paddle moves right
* Rapidly switching between sensors allows quick directional changes

Alternative materials tested included oobleck and kinetic sand, though shaving cream proved to be the most effective.

---

## Controller Interaction

* 2 photoresistors mounted on opposite ends of the container
* Sensors are initially covered with shaving cream
* Players physically move the material to expose one sensor at a time
* Light values are sent from an Arduino to Processing via serial communication
* Paddle position updates based on sensor input thresholds

This interaction encourages playful, physical engagement rather than precise button presses.

---

## Prototyping Process

### Prototype 1 – Concept Sketches

I began by sketching the physical layout and gameplay mapping. The sensors were placed on either end of a container, and the paddle was designed to snap to four discrete positions based on sensor data. This helped define how physical gestures would translate into digital movement.

---

### Prototype 2 – Shaving Cream Interaction Test

I sprayed shaving cream into a container and had users interact with it while testing a very basic Pong game using a Wizard-of-Oz approach.

**Key findings:**

* Players enjoyed the tactile, messy interaction
* Moving shaving cream felt intuitive and playful
* Danny suggested rotating the game so the paddles moved left and right, better matching players’ natural hand motions

This change significantly improved the mapping between physical action and on-screen movement.

---

### Prototype 3 – First Functional Circuit

I built a circuit using an Arduino and two photoresistors, connecting it directly to my Processing game. This removed the need for Wizard-of-Oz control and allowed real sensor data to drive gameplay.

At this stage, I focused on:

* Sensor sensitivity
* Threshold tuning
* Reducing jitter while maintaining responsiveness

---

### Prototype 4 – Expanded Circuit + Material Exploration

I added a second breadboard to spread out the photoresistors, making player input more deliberate and reducing accidental activation.

I also tested oobleck as an alternative control material. While fun to touch, it proved unreliable for light-based sensing due to inconsistent coverage of the sensors.

Feedback from peers and Danny during this stage led to nine major iterations of the Processing code, refining responsiveness, mapping logic, and overall game feel.

---

### Prototype 5 – Final Controller

The final prototype features a boxed enclosure that houses the electronics. This:

* Cleans up the visual presentation
* Reduces interference from ambient room lighting
* Makes the controller feel more finished and intentional

Additional improvements included:

* Power-ups that speed up or slow down the ball
* Sound effects for feedback (movement, bounce, score, serve, lose)
* Tweening/easing for smoother paddle movement
* On-screen instructions for players

---

## Technologies Used

* **Arduino** (hardware input)
* **Photoresistors** (light-based sensing)
* **Processing** (game logic and visuals)
* **Serial communication** (Arduino → Processing)
* **Sound library** for audio feedback

---

## Reflections

This project highlighted how strongly material choice affects interaction design. Shaving cream added a sense of delight and play that traditional controllers lack. Iterative prototyping—from sketches to multiple physical builds—was essential in shaping both the controller and the gameplay.

The final controller is intuitive, responsive, and intentionally playful, showing how unconventional inputs can create engaging user experiences.

---

## Future Improvements

* 3D-printed enclosure for durability
* Integrated haptic feedback
* Support for additional players or sensor types
* Further exploration of alternative tactile materials
