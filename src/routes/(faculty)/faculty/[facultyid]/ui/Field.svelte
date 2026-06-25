<script lang="ts">
    import { onMount } from 'svelte';

    import { viewState } from '../states/view-state.svelte';

    interface Props {
        label: string;
        name: string;
        type?: string;
        defaultValue?: string | Date;
        colStart?: number;
        colSpan?: number;
        immutable?: boolean;
        required?: boolean;
        opts?: string[];
        hasChange?: boolean;
    }

    let {
        label,
        name,
        type,
        defaultValue,
        colStart,
        colSpan,
        immutable,
        required,
        opts,
        hasChange = $bindable(false),
    }: Props = $props();

    const colStartClass = $derived(colStart === undefined ? '' : `col-start-${colStart}`);
    const colSpanClass = $derived(colSpan === undefined ? '' : `col-span-${colSpan}`);

    let domContainer: HTMLLabelElement | null = $state(null);
    onMount(() => {
        if (domContainer) domContainer.classList.remove('hidden');
    });

    const isLocked = $derived(
        viewState.isEditing && immutable && defaultValue !== undefined && defaultValue !== '',
    );

    let currentValue = $state(defaultValue ?? '');
    let validationError = $state('');
    let inputRef: HTMLInputElement | HTMLSelectElement | null = $state(null);
    let formatHint = $state('');

    function getFieldConfig(fieldName: string): {
        pattern?: string;
        maxLength?: number;
        allowedChars?: string;
        format?: (val: string) => string;
        validate?: (val: string) => string;
        hint?: string;
    } {
        const nameLower = fieldName.toLowerCase();

        if (nameLower.includes('philhealth')) {
            return {
                maxLength: 14,
                allowedChars: '0-9\\-',
                format: formatPhilHealth,
                validate: validatePhilHealth,
                hint: '####-####-####',
            };
        }

        if (nameLower.includes('tin')) {
            return {
                maxLength: 15,
                allowedChars: '0-9\\-',
                format: formatTIN,
                validate: validateTIN,
                hint: '###-###-###-###',
            };
        }

        if (nameLower.includes('pagibig')) {
            return {
                maxLength: 12,
                allowedChars: '0-9',
                validate: validatePageIBIG,
                hint: '12 digits (################)',
            };
        }

        if (nameLower.includes('gsis')) {
            return {
                maxLength: 15,
                allowedChars: '0-9\\-',
                format: (val) => val,
                hint: 'GSIS format',
            };
        }

        if (nameLower.includes('employee')) {
            return {
                maxLength: 15,
                allowedChars: '0-9\\-',
                hint: 'Employee ID',
            };
        }

        if (nameLower.includes('psi')) {
            return {
                maxLength: 15,
                allowedChars: '0-9\\-',
                hint: 'PSI Item ID',
            };
        }

        if (nameLower.includes('firstname') || nameLower.includes('first name') ||
            nameLower.includes('lastname') || nameLower.includes('last name') ||
            nameLower.includes('middlename') || nameLower.includes('middle name')) {
            return {
                allowedChars: 'a-zA-Z\\s\\-\\.',
                validate: (val) => /^[a-zA-Z\s\-\.]*$/.test(val) ? '' : 'Only letters, spaces, hyphens and periods allowed',
            };
        }

        if (nameLower.includes('salary') && nameLower.includes('rate')) {
            return {
                pattern: '^[0-9]+(\\.[0-9]{1,2})?$',
                validate: (val) => /^[0-9]+(\.[0-9]{1,2})?$/.test(val) ? '' : 'Must be a positive number',
                hint: 'Positive number (e.g., 50000.50)',
            };
        }

        if (nameLower.includes('salary') && nameLower.includes('grade')) {
            return {
                maxLength: 5,
                allowedChars: '0-9\\-',
                format: formatSalaryGrade,
                validate: validateSalaryGrade,
                hint: '##-#',
            };
        }

        if (nameLower.includes('contact') || nameLower.includes('phone')) {
            return {
                maxLength: 13,
                allowedChars: '0-9\\+',
                format: formatPhoneNumber,
                validate: validatePhoneNumber,
                hint: '09XXXXXXXXX or +639XXXXXXXXX',
            };
        }

        if (nameLower.includes('email')) {
            return {
                validate: validateUPEmail,
                hint: '(name)@up.edu.ph',
            };
        }

        return {};
    }

    function formatPhilHealth(val: string): string {
        const digits = val.replace(/\D/g, '').slice(0, 12);
        if (digits.length <= 4) return digits;
        if (digits.length <= 8) return `${digits.slice(0, 4)}-${digits.slice(4)}`;
        return `${digits.slice(0, 4)}-${digits.slice(4, 8)}-${digits.slice(8)}`;
    }

    function validatePhilHealth(val: string): string {
        const digits = val.replace(/\D/g, '');
        if (digits.length !== 12) return 'PhilHealth No. must be 12 digits (####-####-####)';
        return '';
    }

    function formatTIN(val: string): string {
        const digits = val.replace(/\D/g, '').slice(0, 12);
        if (digits.length <= 3) return digits;
        if (digits.length <= 6) return `${digits.slice(0, 3)}-${digits.slice(3)}`;
        if (digits.length <= 9) return `${digits.slice(0, 3)}-${digits.slice(3, 6)}-${digits.slice(6)}`;
        return `${digits.slice(0, 3)}-${digits.slice(3, 6)}-${digits.slice(6, 9)}-${digits.slice(9)}`;
    }

    function validateTIN(val: string): string {
        const digits = val.replace(/\D/g, '');
        if (digits.length !== 12) return 'TIN must be 12 digits (###-###-###-###: 9 digits + 3 digit branch code)';
        return '';
    }

    function validatePageIBIG(val: string): string {
        const digits = val.replace(/\D/g, '');
        if (digits.length !== 12) return 'Pag-IBIG No. must be 12 digits';
        return '';
    }

    function formatSalaryGrade(val: string): string {
        const digits = val.replace(/\D/g, '').slice(0, 3);
        if (digits.length <= 2) return digits;
        return `${digits.slice(0, 2)}-${digits.slice(2)}`;
    }

    function validateSalaryGrade(val: string): string {
        if (!/^\d{2}-\d$/.test(val) && val !== '') return 'Format: ##-# (e.g., 29-8)';
        return '';
    }

    function formatPhoneNumber(val: string): string {
        const cleaned = val.replace(/\D/g, '');
        if (cleaned.startsWith('63')) {
            return `+63${cleaned.slice(2)}`;
        }
        return `09${cleaned.replace(/^0?9/, '').slice(0, 9)}`;
    }

    function validatePhoneNumber(val: string): string {
        if (!/^(09\d{9}|\+639\d{9})$/.test(val) && val !== '') {
            return 'Format: 09XXXXXXXXX or +639XXXXXXXXX';
        }
        return '';
    }

    function validateUPEmail(val: string): string {
        if (!val) return '';
        if (!/@up\.edu\.ph$/.test(val)) {
            return 'Email must be in format (name)@up.edu.ph';
        }
        return '';
    }

    function handleInput(event: Event) {
        const target = event.target as HTMLInputElement;
        let value = target.value;
        const config = getFieldConfig(name);

        if (config.allowedChars) {
            const allowedRegex = new RegExp(`[^${config.allowedChars}]`, 'g');
            value = value.replace(allowedRegex, '');
        }

        if (config.maxLength && value.length > config.maxLength) {
            value = value.slice(0, config.maxLength);
        }

        if (config.format) {
            value = config.format(value);
        }

        currentValue = value;
        target.value = value;

        if (config.validate) {
            const error = config.validate(value);
            validationError = error;
        }
    }

    function handleChange() {
        const config = getFieldConfig(name);
        if (config.validate && currentValue) {
            const error = config.validate(currentValue);
            validationError = error;
        }
    }

    $effect(() => {
        const config = getFieldConfig(name);
        formatHint = config.hint || '';
    });

    $effect(() => {
        if (!viewState.isEditing) {
            currentValue = defaultValue ?? '';
            validationError = '';
        }

        hasChange = immutable ? false : String(currentValue) !== String(defaultValue ?? '');
    });

    // Safelist Tailwind classes
    // col-span-2 through col-span-10
</script>

<label
    class="flex w-full flex-col gap-2 {colStartClass} {colSpanClass} hidden px-2 sm:flex-row sm:items-center sm:justify-end"
    bind:this={domContainer}
>
    <div class="flex w-full flex-col gap-2 sm:flex-row sm:items-center sm:justify-end">
        <span class="w-full text-left text-sm font-medium sm:mr-2 sm:w-fit sm:text-right">
            {label}

            {#if required && viewState.isEditing}
                <span class="text-fims-red">*</span>
            {/if}
        </span>

        {#if type === 'dropdown'}
            <select
                {name}
                class="h-8 w-full rounded-sm border-0 bg-white p-1 text-black focus:ring-0 disabled:text-black sm:max-w-44 md:max-w-56 lg:max-w-64 xl:max-w-80 {validationError
                    ? 'border-2 border-fims-red'
                    : ''}"
                disabled={!viewState.isEditing || isLocked}
                bind:value={currentValue}
                bind:this={inputRef}
                on:change={handleChange}
                {required}
            >
                <option value="" disabled selected={!defaultValue}>-</option>
                {#if opts}
                    {#each opts as opt}
                        <option value={opt}>{opt}</option>
                    {/each}
                {/if}
            </select>
        {:else if type === 'date'}
            <input
                type="date"
                {name}
                class="h-8 w-full rounded-sm border-0 bg-white p-1 placeholder-fims-gray focus:ring-0 sm:max-w-44 md:max-w-56 lg:max-w-64 xl:max-w-80 {validationError
                    ? 'border-2 border-fims-red'
                    : ''}"
                placeholder="-"
                bind:value={currentValue}
                bind:this={inputRef}
                disabled={!viewState.isEditing || isLocked}
                max={new Date().toISOString().split('T')[0]}
                min="1900-01-01"
                on:input={handleInput}
                on:change={handleChange}
                {required}
            />
        {:else}
            <input
                type={type ?? 'text'}
                {name}
                class="h-8 w-full rounded-sm border-0 bg-white p-1 placeholder-fims-gray focus:ring-0 sm:max-w-44 md:max-w-56 lg:max-w-64 xl:max-w-80 {validationError
                    ? 'border-2 border-fims-red'
                    : ''}"
                placeholder={formatHint || '-'}
                bind:value={currentValue}
                bind:this={inputRef}
                disabled={!viewState.isEditing || isLocked}
                on:input={handleInput}
                on:change={handleChange}
                {required}
            />
        {/if}
    </div>

    {#if validationError}
        <span class="mt-1 text-xs text-fims-red">{validationError}</span>
    {/if}

    {#if formatHint && !validationError}
        <span class="mt-1 text-xs text-fims-gray">Format: {formatHint}</span>
    {/if}

    {#if isLocked}
        <input type="hidden" {name} value={defaultValue ?? ''} />
    {/if}
</label>

<style>
    label {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        width: 100%;
    }
</style>
