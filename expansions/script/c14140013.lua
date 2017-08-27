--广鸟射怪鸟事
local m=14140013
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and e:GetHandler():IsCanBeFusionMaterial(c)
end
function cm.mfilter(c,exg,ec,tp)
	return c:IsFaceup() and exg:IsExists(cm.chkfilter,1,nil,c,ec,tp)
end
function cm.chkfilter(c,tc,ec,chkf)
	local mg=Group.FromCards(tc,ec)
	return cm.CheckFusionMaterialExact(c,mg,chkf)
end
function cm.chkcfilter(c,mg1,mg2,chkf)
	local mg=Group.FromCards(c,ec)
	return cm.CheckFusionMaterialExact(c,mg1,chkf) and cm.CheckFusionMaterialExact(c,mg2,chkf)
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
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chkc then
		local mg1=Group.FromCards(e:GetLabelObject(),e:GetHandler())
		local mg2=Group.FromCards(chkc,e:GetHandler())
		return exg:IsExists(cm.chkcfilter,1,nil,mg1,mg2,tp)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_MZONE,0,1,nil,exg,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectTarget(tp,cm.mfilter,tp,LOCATION_MZONE,0,1,1,nil,exg,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabelObject(g:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or c:IsImmuneToEffect(e) then return end
	local exg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp):Filter(cm.chkfilter,nil,tc,c,tp)
	if exg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=exg:Select(tp,1,1,nil):GetFirst()
	local mg=Group.FromCards(c,tc)
	sc:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_FUSION+REASON_MATERIAL+REASON_EFFECT)
	Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end