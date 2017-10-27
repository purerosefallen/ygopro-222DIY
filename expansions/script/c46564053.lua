--WL·月 观 云 雀
local m=46564053
local cm=_G["c"..m]
function cm.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
end
function cm.setfilter(c)
	return c:IsSetCard(0x65c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.mfilter(c,e,tp,exg,ec)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsAttribute(ATTRIBUTE_LIGHT) and exg:IsExists(cm.chkfilter,1,nil,c,ec,tp)
end
function cm.filter(c,e,tp,tc)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:IsSetCard(0x65c)
end
function cm.chkfilter(c,tc,ec,tp)
	local mg=Group.FromCards(tc,ec)	
	return cm.CheckFusionMaterialExact(c,mg,tp)
end
function cm.CheckFusionMaterialExact(c,g,chkf)
	aux.FCheckAdditional=cm.HoldGroup(g)
	local res=c:CheckFusionMaterial(g,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function cm.HoldGroup(mg)
	return function(tp,g,fc)
		return not (g:IsExists(cm.HoldGroupFilter,1,nil,mg) or mg:IsExists(cm.HoldGroupFilter,1,nil,g))
	end
end
function cm.HoldGroupFilter(c,mg)
	return not mg:IsContains(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,exg,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,exg,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCountFromEx(tp)>0) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 then return end
	local exg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp):Filter(cm.chkfilter,nil,tc,c,tp)
	if exg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=exg:Select(tp,1,1,nil):GetFirst()
	local mg=Group.FromCards(c,tc)
	sc:SetMaterial(mg)
	local rg=mg:Filter(Card.IsAbleToRemove,nil)
	mg:Sub(rg)
	Duel.Remove(rg,POS_FACEUP,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT+REASON_RULE)
	Duel.SendtoGrave(mg,POS_FACEUP,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT+REASON_RULE)
	Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end
