--廓尔喀的幼龙鹰
function c10173061.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173061,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10173261)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10173061.rttg)
	e1:SetOperation(c10173061.rtop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173061,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10173061)
	e2:SetCondition(c10173061.spcon)
	e2:SetTarget(c10173061.sptg)
	e2:SetOperation(c10173061.spop)
	c:RegisterEffect(e2)
	--SpecialSummon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173061,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1,10173161)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c10173061.sptg2)
	e3:SetOperation(c10173061.spop2)
	c:RegisterEffect(e3)
end
function c10173061.spfilter2(c,e,tp)
	return c:IsCode(10173062) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173061.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c10173061.spfilter2,tp,0x13,0,1,Group.FromCards(c,e:GetHandler()),e,tp)
end
function c10173061.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10173061.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) and c:IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10173061.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10173061.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp):GetFirst()
	if tc and Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_EFFECT)~=0 and (tc:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_REMOVED)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c10173061.spfilter2,tp,0x13,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	   end
	end
end
function c10173061.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsSetCard(0xc332)
end
function c10173061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c10173061.cfilter,1,nil,tp)
end
function c10173061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
end
function c10173061.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10173061.rtfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c10173061.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c10173061.rtfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c10173061.rtfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10173061,3))
	local g=Duel.SelectTarget(tp,c10173061.rtfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),tp,LOCATION_REMOVED)
end
function c10173061.rtop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end