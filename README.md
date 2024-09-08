
# GM Notify System

## Join our new community
[Join today!](https://discord.gg/ERmEPsafmR)

## Overview

**gm_notify** is a simple notification script for RedM.

## Features

- **Multiple Notification Types**: Supports different types of notifications (e.g., `warning`, `primary`, `error`, etc.).
- **Custom Duration**: Set custom display duration for each notification.
- **Ox Library Integration**: Optional integration with the `ox_lib` library for extended functionality.
- **HTML/CSS/JavaScript Interface**: Uses a web interface for rendering the notifications, allowing easy customization of the appearance.

## Installation

1. Download or clone this repository.
2. Place the script folder (`gm_notify`) in the appropriate location of your resource directory.
3. Add the following line to your server configuration (`server.cfg`):

    ```bash
    start gm_notify
    ```

## Usage

### Client-side

In your client scripts, you can trigger notifications using the following event:

```lua
TriggerEvent("ws_notify:client:Nofity", "notifyType", "message", duration)
```

- `notifyType`: The type of notification (e.g., `warning`, `primary`, etc.).
- `message`: The message you want to display.
- `duration`: (Optional) The duration of the notification display in milliseconds (default is 5000ms).

### Ox Library Notification

If using `ox_lib`, notifications can be triggered using:

```lua
TriggerEvent("ox_lib:notify", data)
```

Where `data` is a table that can include the following fields:
- `type`: Notification type (e.g., `success`, `error`, etc.).
- `title`: The title of the notification.
- `description`: The description of the notification.
- `duration`: (Optional) The duration of the notification.

### HTML Interface

The notifications are rendered using an HTML interface, allowing for customization of the look and feel of notifications. You can find the HTML, CSS files in the `web` directory.

## Configuration

Configuration options are stored in the `shared/client.lua` file. You can modify options such as:

- `ox_lib_replacement`: Set this to `true` if you're using the `ox_lib` to handle notifications. Please visit https://docs.gamingmultiverse.gr for more info 

## File Structure

```plaintext
gm_notify/
│
├── client/
│   ├── client.lua            # Handles the client-side notification logic.
│   ├── debug.lua             # Debugging tools for the notification system.
│
├── shared/                   # Shared configuration files between client and server.
│   └── client.lua
│
├── fxmanifest.lua             # Resource manifest for FiveM.
├── web/                      # Additional web assets.
```

## Development

1. **Modifying Notification UI**: You can customize the HTML/CSS files in the `web` folder to change the look and feel of the notifications.

## Requirements
- `ox_lib`

## Contributing

Feel free to contribute by submitting issues or pull requests.
