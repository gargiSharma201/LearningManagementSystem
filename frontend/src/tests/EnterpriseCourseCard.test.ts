import { mount } from '@vue/test-utils'
import { describe, expect, it } from 'vitest'
import EnterpriseCourseCard from '@/components/Enterprise/Dashboard/EnterpriseCourseCard.vue'

describe('EnterpriseCourseCard', () => {
	it('shows an enroll CTA and zero progress for a new learner', () => {
		const wrapper = mount(EnterpriseCourseCard, {
			props: {
				course: {
					title: 'Getting Started',
					lessons: 5,
					enrollments: 10,
				},
			},
		})

		expect(wrapper.text()).toContain('Enroll')
		expect(wrapper.text()).toContain('0%')
	})

	it('shows the actual progress and continue action for an enrolled learner', () => {
		const wrapper = mount(EnterpriseCourseCard, {
			props: {
				course: {
					title: 'Advanced Concepts',
					lessons: 8,
					enrollments: 25,
					progress: 42,
					membership: { progress: 42 },
				},
			},
		})

		expect(wrapper.text()).toContain('Continue Learning')
		expect(wrapper.text()).toContain('42%')
	})
})
