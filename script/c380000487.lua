--Xiangke and Xiangsheng
--Effect is not fully implemented
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={71692913,17086528}
s.listed_series={0x98,0x9f,0x99}
function s.filter(c,lv)
	return c:IsMonster() and c:IsLevel(lv)
end
function s.exfilter(c)
	return c:IsMonster() and not ((c:IsSetCard(0x9f) or c:IsSetCard(0x99)) or (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x98)))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,5,nil,4)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,5,nil,7)
	and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		--skill
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
function s.pendfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x99) and c:IsAttackBelow(2500)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.pendfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,71692913)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,17086528)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Add 1 "Odd-Eyes" Pendulum Monster with 2500 ATK or lower from your hand to your Extra Deck face-up
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.pendfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoExtraP(g,nil,REASON_RULE)
	end
	--place 1 "Xiangke Magician" and 1 "Xiangsheng Magician" to your Pendulum Zones from your hand/Deck
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local pend1=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,71692913)
	if #pend1>0 then
		Duel.MoveToField(pend1:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local pend2=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,17086528)
	if #pend2>0 then
		Duel.MoveToField(pend2:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		--Then, change the Pendulum Scale of "Xiangsheng Magician" in your Pendulum Zone to 8
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		pend2:GetFirst():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		pend2:GetFirst():RegisterEffect(e2)
	end
end
