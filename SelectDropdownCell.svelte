<script lang="ts">
    import Icon from '@iconify/svelte';

    interface Props {
        name?: string;
        opts: string[];
        selectedOpt?: string | null;
        defaultSelectedOpt: string | null;
        isEditable: boolean;
        hasChange?: boolean;
        isRequired?: boolean;
        isCombobox?: boolean;
    }

    let {
        name,
        opts,
        selectedOpt = $bindable(),
        defaultSelectedOpt,
        isEditable,
        hasChange = $bindable(),
        isRequired = false,
        isCombobox = false,
    }: Props = $props();

    $effect(() => {
        if (hasChange !== undefined) hasChange = selectedOpt !== defaultSelectedOpt;
    });

    let isDropdownOpen = $state(false);
    let containerRef = $state<HTMLDivElement | null>(null);
    let lastKeyTime = $state(0);
    let keyBuffer = $state('');

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
                selectedOpt = matchingOpt;
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
</script>

<div class="relative h-full w-full" bind:this={containerRef}>
    {#if isEditable}
        {#if isCombobox}
            <div class="relative flex h-full w-full items-center">
                <input
                    type="text"
                    data-testid={`${name}-combobox`}
                    class="h-full w-full border-0 bg-transparent px-0 pl-1 focus:ring-0"
                    bind:value={selectedOpt}
                    placeholder={defaultSelectedOpt !== '-' ? defaultSelectedOpt : ''}
                    onclick={() => (isDropdownOpen = true)}
                />
                <button
                    type="button"
                    data-testid={name}
                    class="absolute right-1 h-full w-4"
                    onclick={() => (isDropdownOpen = !isDropdownOpen)}
                    tabindex="-1"
                >
                    <Icon
                        icon={isDropdownOpen ? 'tabler:chevron-up' : 'tabler:chevron-down'}
                        class="h-full w-full"
                    />
                </button>
            </div>
        {:else}
            <button
                type="button"
                data-testid={name}
                class="relative h-full w-full"
                onclick={() => {
                    if (isEditable) isDropdownOpen = !isDropdownOpen;
                }}
            >
                <span>{selectedOpt ? selectedOpt : defaultSelectedOpt}</span>
                <Icon
                    icon={isDropdownOpen ? 'tabler:chevron-up' : 'tabler:chevron-down'}
                    class="absolute top-0 right-5 h-full w-4"
                />
            </button>
        {/if}
    {:else}
        <div class="flex h-full items-center justify-center">
            <span>{selectedOpt ? selectedOpt : defaultSelectedOpt}</span>
        </div>
    {/if}

    {#if isEditable}
        <div
            class="rounded-lg p-1 {isDropdownOpen
                ? 'block'
                : 'hidden'} absolute z-50 max-h-80 w-full overflow-y-auto bg-white shadow-lg"
        >
            {#each opts as opt (opt)}
                {#if opt === selectedOpt}
                    <button
                        type="button"
                        class="flex w-full rounded-sm p-3 hover:bg-[#e9e9e9]"
                        onclick={() => {
                            selectedOpt = defaultSelectedOpt;
                            isDropdownOpen = false;
                        }}
                    >
                        <Icon icon="tabler:check" class="h-6 w-8 pr-2 text-fims-green" />
                        <span class="text-left">{selectedOpt}</span>
                    </button>
                {:else}
                    <button
                        type="button"
                        class="flex w-full rounded-sm p-3 hover:bg-[#e9e9e9]"
                        onclick={() => {
                            selectedOpt = opt;
                            isDropdownOpen = false;
                        }}
                    >
                        <div class="w-8 pr-2"></div>
                        <span class="text-left">{opt}</span>
                    </button>
                {/if}
            {/each}
        </div>
    {/if}

    <input
        type="text"
        value={!selectedOpt || selectedOpt === '-' ? '' : selectedOpt}
        class="sr-only"
        required={isRequired}
        tabindex="-1"
    />

    <input
        type="hidden"
        {name}
        value={!selectedOpt || selectedOpt === '-' ? defaultSelectedOpt : selectedOpt}
    />
</div>
