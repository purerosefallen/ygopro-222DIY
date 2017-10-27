--雪 精 灵 的 祈 鸣
local m=46564038
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.valcheck(c,rc)
	local rlv=c:GetRitualLevel(rc)
	if c:IsHasEffect(EFFECT_RITUAL_LEVEL) and bit.band(rlv,0xf0000)~=0 and (bit.band(rlv,0xf0000)==rc:GetLevel()*0x10000 or bit.band(rlv,0xf)==rc:GetLevel()) then --Debug.ShowHint(rlv)
		return bit.bor(rc:GetLevel()*2,c:GetLevel()*0x10000)
	else
		return rlv
	end
end
function cm.filter(c,e,tp,m1,m2,ft)
	if not c:IsAttribute(ATTRIBUTE_WATER) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(cm.valcheck,c:GetLevel()*2,1,99,c)
	else
		return ft>-1 and mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
	end
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(cm.valcheck,rc:GetLevel()*2,0,99,rc)
	else return false end
end
function cm.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsAttribute,nil,ATTRIBUTE_WATER)
		local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetMZoneCount(tp)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,cm.valcheck,tc:GetLevel()*2,1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,cm.valcheck,tc:GetLevel()*2,0,99,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end