<script lang="ts">
  import VisibilityProvider from "./providers/VisibilityProvider.svelte";
  import Notify from "./components/Notify.svelte";
  import { debugData } from "./utils/debugData";

  debugData([
    {
      action: "setVisible",
      data: true,
    },
  ]);
</script>

<main class="select-none">
  <Notify />
</main>
