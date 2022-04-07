--Supernatural Tactics
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_names={CARD_JINZO,66362965,39978267}
function s.counterfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsMonster() and (c:GetControler()~=c:GetOwner() or aux.IsCodeListed(c,CARD_JINZO))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
end
s.filter=aux.FilterFaceupFunction(Card.IsType,TYPE_TRAP)
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Send 1 monster on your field that originally belonged to your opponent or a monster on your field with "Jinzo" in its text to the Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoGrave(tc,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
	Duel.BreakEffect()
	--play 1 "The Fiend Megacyber" from outside of your Deck
	local token=Duel.CreateToken(tp,66362965)
	if token then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		token:RegisterEffect(e0)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1)
	end
	if not Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		--place 1 face-up "Cyber Raider" to your opponent's Spell & Trap Zone from outside of your Deck as a Continuous Trap Card
		local token1=Duel.CreateToken(tp,39978267)
		if not Duel.MoveToField(token1,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then return end
		--Treated as a Continuous Trap
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		token1:RegisterEffect(e1)
	end
	--Cannot Special Summon monsters, except Machine monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,2),nil)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_MACHINE)
end
