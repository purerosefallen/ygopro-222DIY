--圣谕歌姬 伊莎蓓尔
function c10102006.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c10102006.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2)
	local e4=e1:Clone()
	e4:SetCode(EVENT_RELEASE) 
	e4:SetCondition(c10102006.con)
	c:RegisterEffect(e4)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10102006)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10102006.spcost)
	e3:SetTarget(c10102006.sptg)
	e3:SetOperation(c10102006.spop)
	c:RegisterEffect(e3) 
	c10102006[c]=e3  
end
function c10102006.filter(c,e,tp)
	return c:IsSetCard(0x9330) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10102006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10102006.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10102006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10102006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local rg=Duel.GetMatchingGroup(c10102006.rfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	   if rg:GetCount()>0 then 
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
		  local rg2=rg:Select(tp,1,1,nil)
		  Duel.Release(rg2,REASON_EFFECT) 
	   end
	end
end
function c10102006.rfilter(c)
	return c:IsSetCard(0x9330) and c:IsReleasableByEffect() and (c:IsFaceup() or not c:IsOnField()) and c:IsType(TYPE_MONSTER)
end
function c10102006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10102006.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetReasonCard()~=e:GetHandler()
end
function c10102006.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10102006)~=0 then return end
	Duel.Hint(HINT_CARD,0,10102006)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9330))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,10102006,RESET_PHASE+PHASE_END,0,1)
end