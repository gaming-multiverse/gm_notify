<script lang="ts">
  import { fly, fade } from "svelte/transition";
  import { onMount } from "svelte";
  import { useNuiEvent } from "../utils/useNuiEvent";
  import { fetchNui } from "../utils/fetchNui";
  import scoretimer_generic_tick from "/images/scoretimer_generic_tick.png";
  import scoretimer_generic_cross from "/images/scoretimer_generic_cross.png";
  import menu_icon_alert from "/images/menu_icon_alert.png";
  import help_text_bg from "/images/help_text_bg.png";

  let notificationsBeingDisplayed = [];

  let maxNotifications: number;

  function fetchMaxNotifications() {
    fetchNui("ws_notify:nui:sendMaxVisibleNotifications")
      .then((data) => {
        maxNotifications = data;
      })
      .catch((error) => {
        maxNotifications = 4;
        console.log("something is wrong please check your config");
      });
  }

  function addNotification(notifyType, message, duration) {
    const id = Date.now() + Math.random();

    const notification = {
      id,
      notifyType,
      message,
      duration,
      progress: 100,
      textContainerHeight: 0,
      interval: null,
    };

    if (notificationsBeingDisplayed.length >= maxNotifications) {
      const oldestNotification = notificationsBeingDisplayed.shift();
      clearInterval(oldestNotification.interval);
    }

    notificationsBeingDisplayed = [
      ...notificationsBeingDisplayed,
      notification,
    ];

    startProgress(notification);
  }

  function startProgress(notification) {
    const totalDuration = notification.duration;
    const steps = 100;
    const intervalDuration = totalDuration / steps;

    const interval = setInterval(() => {
      if (notification.progress > 0) {
        notification.progress -= 1;

        notificationsBeingDisplayed = [...notificationsBeingDisplayed];
      } else {
        notification.progress = 0;
        clearInterval(interval);

        notificationsBeingDisplayed = notificationsBeingDisplayed.filter(
          (n) => n.id !== notification.id
        );
      }
    }, intervalDuration);

    notification.interval = interval;
  }

  useNuiEvent("displayNotification", (data: any) => {
    addNotification(data.notifyType, data.message, data.duration);
  });

  function measureHeight(node, notification) {
    notification.textContainerHeight = node.offsetHeight;

    notificationsBeingDisplayed = [...notificationsBeingDisplayed];

    const observer = new ResizeObserver(() => {
      notification.textContainerHeight = node.offsetHeight;

      notificationsBeingDisplayed = [...notificationsBeingDisplayed];
    });

    observer.observe(node);

    return {
      destroy() {
        observer.disconnect();
      },
    };
  }

  onMount(() => {
    fetchMaxNotifications();
    // addNotification("info", "First notification (oldest).", 120000);
  });
</script>

<div
  class="absolute top-1/2 right-0 h-auto flex flex-col items-center space-y-4 translate-y-[-50%] overflow-hidden"
>
  {#each notificationsBeingDisplayed as notification (notification.id)}
    <div
      class="flex justify-end items-center"
      in:fade={{ duration: 500 }}
      out:fly={{ x: 50, duration: 500 }}
    >
      <div class="relative pr-4">
        <img
          src={help_text_bg}
          alt="helptextbg"
          class="w-[21rem]"
          style="height: {notification.textContainerHeight + 40}px;"
        />

        <div class="absolute top-0 left-0 w-full h-full flex pl-6 items-center">
          <div class="relative" in:fly={{ x: -50, duration: 800 }}>
            {#if notification.notifyType === "primary" || notification.notifyType === "success"}
              <img
                src={scoretimer_generic_tick}
                alt="primary"
                class="relative left-[0.3rem] top-[0.2rem] w-4"
              />
            {:else if notification.notifyType === "error"}
              <img
                src={scoretimer_generic_cross}
                alt="error"
                class="relative left-[0.28rem] top-1 w-4"
              />
            {:else}
              <img
                src={menu_icon_alert}
                alt="warning or info"
                class="relative left-[0.05rem] top-0 w-6"
              />
            {/if}

            {#if notification.progress > 0}
              <svg
                class="absolute -top-[7px] -left-[5px] w-9 h-9 transform -rotate-90"
                viewBox="0 0 36 36"
              >
                <circle
                  class="text-black"
                  stroke-width="3"
                  stroke="currentColor"
                  fill="none"
                  cx="18"
                  cy="18"
                  r="15.915"
                />
                <circle
                  class="text-white"
                  stroke-width="3"
                  stroke-dasharray={`${notification.progress}, 100`}
                  stroke-linecap="round"
                  stroke="currentColor"
                  fill="none"
                  cx="18"
                  cy="18"
                  r="15.915"
                />
              </svg>
            {/if}
          </div>
        </div>

        <div
          class="absolute top-1/2 left-[54%] transform -translate-x-1/2 -translate-y-1/2 w-[14rem]"
          use:measureHeight={notification}
        >
          <div
            class="text-white break-words font-[redm-font] text-lg"
            in:fly={{ x: 50, duration: 800 }}
          >
            {notification.message}
          </div>
        </div>
      </div>
    </div>
  {/each}
</div>
