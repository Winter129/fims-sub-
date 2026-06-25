<script lang="ts">
    import { viewState } from '../../../states/view-state.svelte';

    interface Props {
        label: string;
        name: string;
        opts: string[];
        defaultSelectedOpt: string | null;
        colStart?: number;
        colSpan?: number;
        immutable?: boolean;
        hasChange?: boolean;
    }

    let {
        label,
        name,
        opts,
        defaultSelectedOpt,
        colStart,
        colSpan,
        immutable,
        hasChange = $bindable(false),
    }: Props = $props();

    const colStartClass = $derived(colStart === undefined ? '' : `col-start-${colStart}`);
    const colSpanClass = $derived(colSpan === undefined ? '' : `col-span-${colSpan}`);

    // svelte-ignore state_referenced_locally
    let currentSelectedOpt = $state(defaultSelectedOpt ?? '');
    // svelte-ignore state_referenced_locally
    let lastDefault = $state(defaultSelectedOpt ?? '');

    $effect(() => {
        if (defaultSelectedOpt !== lastDefault) {
            currentSelectedOpt = defaultSelectedOpt ?? '';
            lastDefault = defaultSelectedOpt ?? '';
        }
        if (!viewState.isEditing) currentSelectedOpt = defaultSelectedOpt ?? '';

        hasChange = immutable ? false : currentSelectedOpt !== (defaultSelectedOpt ?? '');
    });
</script>

<div class="relative w-full min-w-0 {colStartClass} {colSpanClass}">
    <div class="flex w-full flex-col gap-2 sm:flex-row sm:items-center sm:justify-end">
        <span class="w-full text-left text-sm font-medium sm:mr-2 sm:w-fit sm:text-right">{label}</span>
        {#if viewState.isEditing && (!immutable || (immutable && currentSelectedOpt === ''))}
            <select
                {name}
                class="h-10 w-full min-w-0 rounded-sm border border-gray-200 bg-white px-2 py-2 text-left shadow-sm sm:max-w-44 md:max-w-56 lg:max-w-64 xl:max-w-80"
                bind:value={currentSelectedOpt}
            >
                <option value="">-</option>
                {#each opts as opt (opt)}
                    <option value={opt}>{opt}</option>
                {/each}
            </select>
        {:else}
            <span
                class="block h-10 w-full min-w-0 content-center rounded-sm border border-gray-200 bg-white px-2 py-2 text-left sm:max-w-44 md:max-w-56 lg:max-w-64 xl:max-w-80"
                >{currentSelectedOpt || '-'}</span
            >
        {/if}
    </div>

    <input type="hidden" {name} value={currentSelectedOpt || ''} />
</div>
