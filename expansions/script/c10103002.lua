--界限龙王 努特
function c10103002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10103002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10103002)
	e1:SetLabel(1)
	e1:SetCost(c10103002.spcost)
	e1:SetTarget(c10103002.sptg)
	e1:SetOperation(c10103002.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(10103002,1))
	e2:SetCountLimit(1,10103102)
	e2:SetLabel(2)
	e2:SetCondition(c10103002.spcon)
	c:RegisterEffect(e2)
end
function c10103002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x337)
end
function c10103002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,e:GetLabel(),REASON_COST) and (e:GetHandler():GetAttackAnnouncedCount()==0 or e:GetLabel()~=2) end
	if e:GetLabel()==2 then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CANNOT_ATTACK)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	   e:GetHandler():RegisterEffect(e1)
	end
	e:GetHandler():RemoveOverlayCard(tp,e:GetLabel(),e:GetLabel(),REASON_COST)
end
function c10103002.spfilter(c,e,tp)
	return c:IsSetCard(0x337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10103002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if e:GetLabel()==1 then loc=LOCATION_HAND+LOCATION_GRAVE 
	else loc=LOCATION_DECK 
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10103002.spfilter,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c10103002.spop(e,tp,eg,ep,ev,re,r,rp)  
	local loc=0
	if e:GetLabel()==1 then loc=LOCATION_HAND+LOCATION_GRAVE 
	else loc=LOCATION_DECK 
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10103002.spfilter,tp,loc,0,1,1,nil,e,tp):GetFirst()
	if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
end