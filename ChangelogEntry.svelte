<script lang="ts">
    type Props = {
        timestamp: Date;
        email: string;
        info: string;
    };

    const { timestamp, email, info }: Props = $props();
</script>

<!-- 
notes:
not entirely sure what's the correct bg color for this component
-->
<div
    data-testid="changelog-entry"
    class="flex w-auto flex-col border-b-1 border-b-fims-gray bg-gray-100 px-3 py-2"
>
    <div class="flex justify-between items-start gap-4">
        <div class="flex flex-col">
            <p class="text-sm">{email}</p>
            <p class="pt-1 text-lg">{info}</p>
        </div>
        <p class="text-sm whitespace-nowrap">
            {timestamp.toLocaleDateString()} {timestamp.toLocaleTimeString()}
        </p>
    </div>
</div>
