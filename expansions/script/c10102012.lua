--圣谕暗魔女 艾西
function c10102012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10102012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10102012)
	e1:SetCost(c10102012.spcost)
	e1:SetTarget(c10102012.sptg)
	e1:SetOperation(c10102012.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10102012,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10102112)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c10102012.syncost)
	e2:SetTarget(c10102012.syntg)
	e2:SetOperation(c10102012.synop)
	c:RegisterEffect(e2)
	c10102012[c]=e2 
end
function c10102012.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10102012.filter1(c,e,tp,rc)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0x9330) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c10102012.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv,rc) and c~=rc
end
function c10102012.filter2(c,e,tp,lv,rc)
	local lv2=c:GetLevel()
	return lv>0 and c:IsSetCard(0x9330) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c10102012.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+lv2) and c~=rc
end
function c10102012.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x9330) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c10102012.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,rc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c10102012.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c10102012.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c10102012.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetLevel(),nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10102012.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local lv=g:GetFirst():GetLevel()+g:GetNext():GetLevel()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=2 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c10102012.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if sg:GetCount()>0 and Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
	   sg:GetFirst():CompleteProcedure()
	end
end
function c10102012.costfilter(c)
	return c:IsSetCard(0x9330) and c:IsType(TYPE_MONSTER)
end
function c10102012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c10102012.costfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupEx(tp,c10102012.costfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c10102012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10102012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end