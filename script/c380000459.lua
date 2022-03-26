--Fang of Rebellion: Dark Rebellion
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
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
s.listed_names={77462146,16195942}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		for i=1,2 do
			local token=Duel.CreateToken(tp,77462146)
			Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		local token2=Duel.CreateToken(tp,16195942)
		Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_RULE)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
function s.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
s.filter=aux.FilterFaceupFunction(Card.IsCode,16195942)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return aux.CanActivateSkill(tp) and #g==1
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil,g:GetFirst():GetAttack())
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--1 "Dark Rebellion Xyz Dragon" you control
	local g=Duel.GetFirstMatchingCard(s.filter,tp,LOCATION_MZONE,0,nil)
	Duel.HintSelection(g)
	if g then
		--attach up to 2 cards in your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,2,nil)
		if #sg>0 then
			Duel.Overlay(g,sg)
		end
	end
end
