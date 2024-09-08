<script lang="ts">
  import { fade, fly } from "svelte/transition";
  import { useNuiEvent } from "../utils/useNuiEvent";
  import { onMount } from "svelte";
  import scoretimer_generic_tick from "/images/scoretimer_generic_tick.png";
  import scoretimer_generic_cross from "/images/scoretimer_generic_cross.png";
  import menu_icon_alert from "/images/menu_icon_alert.png";
  import help_text_bg from "/images/help_text_bg.png";

  let progress = 100;
  let isNotifyVisible = false;
  let showProgressBar = true;

  let notificationQueue = []; // Queue to manage notifications
  let currentNotification = null; // The currently displayed notification
  let textContainerHeight = 0; // To store the dynamic height of the text container

  function addNotification(notifyType, message, duration) {
    const id = Date.now();
    notificationQueue.push({ id, notifyType, message, duration });

    // If no notification is currently displayed, start processing the queue
    if (!currentNotification) {
      processQueue();
    }
  }

  function processQueue() {
    if (notificationQueue.length === 0) {
      currentNotification = null;
      return;
    }

    currentNotification = notificationQueue.shift(); // Get the next notification in the queue
    isNotifyVisible = true;

    startProgress(currentNotification.duration).then(() => {
      removeNotification(currentNotification.id);
      isNotifyVisible = false;
      setTimeout(() => {
        processQueue(); // Process the next notification in the queue after fade-out
      }, 1000); // Ensure this matches the fade-out duration
    });
  }

  function removeNotification(id) {
    notificationQueue = notificationQueue.filter(
      (notification) => notification.id !== id
    );
  }

  function startProgress(totalDuration) {
    return new Promise((resolve) => {
      progress = 100; // Reset progress

      const steps = 100; // 100 steps
      const intervalDuration = totalDuration / steps; // Calculate interval per step

      const interval = setInterval(() => {
        if (progress > 0) {
          progress -= 1; // Decrease progress by 1 each interval
        } else {
          progress = 0;
          clearInterval(interval); // Stop the interval when progress reaches 0
          showProgressBar = false; // Hide the progress bar
          setTimeout(() => {
            resolve(); // Resolve the promise when progress completes
          }, 500); // Optional delay before fade-out
        }
      }, intervalDuration);
    });
  }

  /* onMount(() => {
    // Example notification to test
    addNotification(
      "info",
      "This is a test notification with a much longer message to see how the component handles wrapping and displaying of text. ",
      153500
    );
  }); */

  useNuiEvent("displayNotification", (data: any) => {
    addNotification(data.notifyType, data.message, data.duration);
  });

  // Reactively update the height of the text container
  $: if (currentNotification) {
    setTimeout(() => {
      const textContainer = document.getElementById("text-container");
      if (textContainer) {
        textContainerHeight = textContainer.offsetHeight;
      }
    }, 0);
  }
</script>

<div class="overflow-hidden">
  {#if isNotifyVisible && currentNotification}
    <div
      class="flex h-screen justify-end items-center"
      in:fade={{ duration: 1000 }}
      out:fly={{ x: 50, duration: 1000 }}
    >
      <div class="relative pr-4">
        <!-- Image with dynamic height -->
        <img
          src={help_text_bg}
          alt="helptextbg"
          class=" w-[21rem]"
          style="height: {textContainerHeight + 40}px;"
        />

        <div
          class="absolute top-0 left-0 w-full h-full flex justify-left pl-6 items-center"
        >
          <div class="relative" in:fly={{ x: -50, duration: 800 }}>
            {#if currentNotification.notifyType == "primary" || currentNotification.notifyType == "success"}
              <img
                src={scoretimer_generic_tick}
                alt="primary"
                class="relative left-[0.3rem] top-[0.2rem] w-4"
              />
            {:else if currentNotification.notifyType == "error"}
              <img
                src={scoretimer_generic_cross}
                alt="error"
                class="relative left-[0.28rem] top-1 w-4"
              />
            {:else if currentNotification.notifyType == "warning" || currentNotification.notifyType == "info"}
              <img
                src={menu_icon_alert}
                alt="warning or info"
                class="relative left-[0.05rem] top-0 w-6"
              />
            {/if}

            <!-- Conditional rendering of Circular Progress Bar -->
            {#if progress > 0}
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
                  stroke-dasharray={`${progress}, 100`}
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

        <!-- Text with fly-in animation and dynamic height measurement -->
        <div
          id="text-container"
          class="absolute top-1/2 left-[54%] transform -translate-x-1/2 -translate-y-1/2 w-[14rem] flex justify-left items-center"
        >
          <div
            class="text-white break-words whitespace-normal font-[redm-font] text-lg"
            in:fly={{ x: 50, duration: 800 }}
          >
            {currentNotification.message}
          </div>
        </div>
      </div>
    </div>
  {/if}
</div>
