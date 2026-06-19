<script lang="ts">
    import Icon from '@iconify/svelte';

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
    let isDropdownOpen = $state(false);
    let containerRef = $state<HTMLDivElement | null>(null);
    let lastKeyTime = $state(0);
    let keyBuffer = $state('');

    const colStartClass = $derived(colStart === undefined ? '' : `col-start-${colStart}`);
    const colSpanClass = $derived(colSpan === undefined ? '' : `col-span-${colSpan}`);

    // svelte-ignore state_referenced_locally
    let currentSelectedOpt = $state(defaultSelectedOpt);
    // svelte-ignore state_referenced_locally
    let lastDefault = $state(defaultSelectedOpt);

    function handleClickOutside(event: MouseEvent) {
        if (containerRef && !containerRef.contains(event.target as Node)) {
            isDropdownOpen = false;
        }
    }

    function handleKeyPress(event: KeyboardEvent) {
        const now = Date.now();
        if (now - lastKeyTime > 500) {
            keyBuffer = '';
        }
        lastKeyTime = now;

        const char = event.key.toLowerCase();
        if (/^[a-z0-9]$/.test(char)) {
            keyBuffer += char;
            const matchingOpt = opts.find((opt) =>
                opt.toLowerCase().startsWith(keyBuffer)
            );
            if (matchingOpt) {
                currentSelectedOpt = matchingOpt;
            }
        }
    }

    $effect(() => {
        if (isDropdownOpen) {
            document.addEventListener('mousedown', handleClickOutside);
            document.addEventListener('keydown', handleKeyPress);
            return () => {
                document.removeEventListener('mousedown', handleClickOutside);
                document.removeEventListener('keydown', handleKeyPress);
            };
        }
    });
    $effect(() => {
        if (defaultSelectedOpt !== lastDefault) {
            currentSelectedOpt = defaultSelectedOpt;
            lastDefault = defaultSelectedOpt;
        }
        if (!viewState.isEditing) currentSelectedOpt = defaultSelectedOpt;

        hasChange = immutable ? false : currentSelectedOpt !== defaultSelectedOpt;
    });
</script>

<div class="relative w-full {colStartClass} {colSpanClass}" bind:this={containerRef}>
    <div class="flex w-full items-center justify-end">
        <span class="mr-2 w-fit text-right">{label}</span>
        {#if viewState.isEditing && (!immutable || (immutable && currentSelectedOpt === null))}
            <button
                type="button"
                class="relative h-8 w-45 rounded-sm bg-white px-1.5 text-left 2xl:w-75"
                onclick={() => {
                    isDropdownOpen = !isDropdownOpen;
                }}
            >
                <span>{currentSelectedOpt ? currentSelectedOpt : '-'}</span>
                <Icon
                    icon={isDropdownOpen ? 'tabler:chevron-up' : 'tabler:chevron-down'}
                    class="absolute top-2 right-1.5 h-4 w-4"
                />
            </button>
        {:else}
            <span
                class="block h-8 w-45 content-center rounded-sm bg-white px-1.5 text-left 2xl:w-75"
                >{currentSelectedOpt ?? '-'}</span
            >
        {/if}
    </div>

    <div
        class="absolute z-50 w-full rounded-lg bg-white p-1 shadow-lg max-h-80 overflow-y-auto {isDropdownOpen
            ? 'block'
            : 'hidden'}"
    >
        {#each opts as opt (opt)}
            {#if opt === currentSelectedOpt}
                <button
                    type="button"
                    class="flex w-full rounded-sm p-3 hover:bg-[#e9e9e9]"
                    onclick={() => {
                        currentSelectedOpt = null;
                        isDropdownOpen = false;
                    }}
                >
                    <Icon icon="tabler:check" class="h-6 w-8 pr-2 text-fims-green" />
                    <span>{currentSelectedOpt}</span>
                </button>
            {:else}
                <button
                    type="button"
                    class="flex w-full rounded-sm p-3 hover:bg-[#e9e9e9]"
                    onclick={() => {
                        currentSelectedOpt = opt;
                        isDropdownOpen = false;
                    }}
                >
                    <div class="w-8 pr-2"></div>
                    <span>{opt}</span>
                </button>
            {/if}
        {/each}
    </div>

    <input type="hidden" {name} value={currentSelectedOpt} />
</div>
