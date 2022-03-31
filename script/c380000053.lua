--Tether of Defeat
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYED)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCountLimit(1)
		e1:SetCondition(s.tgcon)
		e1:SetOperation(s.tgop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	--flag register
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0)
	and Duel.GetFlagEffect(ep,id)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--choose
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	--send to grave
	local g=nil
	if op==0 then
		g=Duel.GetDecktopGroup(tp,1)
	else
		g=Duel.GetDecktopGroup(1-tp,1)
	end
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(tc,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
	--flag
	Duel.ResetFlagEffect(ep,id)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
