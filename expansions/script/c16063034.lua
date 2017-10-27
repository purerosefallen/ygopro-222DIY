--juexing--
function c16063034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16063034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c16063034.target)
	e1:SetOperation(c16063034.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c16063034.thcon)
	e2:SetTarget(c16063034.thtg)
	e2:SetOperation(c16063034.thop)
	c:RegisterEffect(e2)
end
function c16063034.filter(c,e,tp)
	return c:IsSetCard(0x5c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16063034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c16063034.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c16063034.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063034.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetOperation(c16063034.desop)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetCountLimit(1)
			tc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()	  
	end
end
function c16063034.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c16063034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c16063034.sfilter(c)
	return  c:IsSetCard(0x5c5) and c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)  and c:IsSSetable()
end
function c16063034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c16063034.sfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c16063034.thop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local setg=Duel.SelectMatchingCard(tp,c16063034.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		 if setg:GetCount()>0 then
			if Duel.SSet(tp,setg) >0 then
			Duel.ConfirmCards(1-tp,setg)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end