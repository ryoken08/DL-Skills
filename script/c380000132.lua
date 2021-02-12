--Cyber Energy Amplified
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={303660}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_EQUIP)
		e1:SetOperation(s.equipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.equipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:GetFirst()
	local tc=g:GetEquipTarget()
	if tc and g:IsCode(303660) and tc:IsControler(tp) then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		--500 ATK increase
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
function s.filter(c)
	return c:GetEquipCount()~=0 and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,303660)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		local atk=tc:GetEquipGroup():FilterCount(Card.IsCode,nil,303660)*300
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
