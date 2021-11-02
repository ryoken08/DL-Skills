--End of the World
--Effect is not fully implemented
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
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCondition(s.spcon)
		ge1:SetOperation(s.spop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_names={47198668}
s.listed_series={0x10af,0xae}
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsCode(47198668) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_HAND)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,3,nil,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	--flag register
	Duel.RegisterFlagEffect(ep,id+1,RESET_PHASE+PHASE_END,0,0)
end
function s.exfilter(c)
	return (c:IsMonster() and c:IsSetCard(0x10af)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xae))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,12,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
function s.filter(c)
	return c:IsCode(47198668) and not c:IsPublic()
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x10af)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA,0,1,nil))
	local b2=(Duel.GetFlagEffect(ep,id+1)>0 and Duel.GetFlagEffect(ep,id+2)==0 and Duel.IsExistingMatchingCard(aux.NOT(Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,47198668))
	return aux.CanActivateSkill(tp)
	and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA,0,1,nil))
	local b2=(Duel.GetFlagEffect(ep,id+1)>0 and Duel.GetFlagEffect(ep,id+2)==0 and Duel.IsExistingMatchingCard(aux.NOT(Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,47198668))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--opd register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--reveal 1 "D/D/D Doom King Armageddon" in your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		end
		--Add 1 face-up "D/D/D" Pendulum Monster to your hand from your Extra Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_RULE)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,sg)
			--cannot Summon the card added, except by Pendulum Summoning
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.sumlimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetTarget(s.splimit)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_MSET)
			Duel.RegisterEffect(e3,tp)
			--cannot activate the card added
			local e4=e1:Clone()
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetValue(s.aclimit)
			Duel.RegisterEffect(e4,tp)
		end
	else
		--opt register
		Duel.RegisterFlagEffect(ep,id+2,RESET_PHASE+PHASE_END,0,0)
		--Destroy all monsters on the field except for "D/D/D Doom King Armageddon"
		local sg=Duel.GetMatchingGroup(aux.NOT(Card.IsCode),tp,LOCATION_MZONE,LOCATION_MZONE,nil,47198668)
		if #sg>0 then
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
				e1:SetReset(RESET_CHAIN)
				tc:RegisterEffect(e1)
				tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
			end
			Duel.SendtoGrave(sg,REASON_DESTROY)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (sumtype&SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM and c:IsCode(e:GetLabel())
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
