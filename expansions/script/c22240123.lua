--Solid 一零零三
function c22240123.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,0x81),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240123,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22240123.xyzcon)
	e1:SetOperation(c22240123.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240123,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22240123.condition)
	e1:SetTarget(c22240123.target)
	e1:SetOperation(c22240123.operation)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22240123,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22240123)
	e3:SetCost(c22240123.thcost)
	e3:SetTarget(c22240123.thtg)
	e3:SetOperation(c22240123.thop)
	c:RegisterEffect(e3)
end
c22240123.named_with_Solid=1
function c22240123.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22240123.xyzfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and bit.band(c:GetOriginalType(),0x81)==0x81
end
function c22240123.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local olg=Duel.GetMatchingGroup(c22240123.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then return true end
end
function c22240123.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local olg=Duel.GetMatchingGroup(c22240123.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then
		local g=olg:Select(tp,2,2,nil)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	end
end
function c22240123.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22240123.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c22240123.IsSolid(c)
end
function c22240123.filter(c,e,tp,m,ft)
	if not c22240123.ritual_filter(c) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return mg:IsExists(c22240123.mfilterf,1,nil,tp,mg,c)
	end
end
function c22240123.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c22240123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetMZoneCount(tp)
		return ft>-1 and e:GetHandler():GetOverlayGroup():FilterCount(c22240123.filter,nil,e,tp,mg,ft)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c22240123.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=e:GetHandler():GetOverlayGroup():Filter(c22240123.filter,nil,e,tp,mg,ft)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c22240123.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c22240123.thcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(c)
	e1:SetCountLimit(1)
	e1:SetOperation(c22240123.reop)
	Duel.RegisterEffect(e1,tp)
end
function c22240123.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22240123.sfilter(c,e)
	return bit.band(c:GetType(),0x81)==0x81 and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsCanBeEffectTarget(e)
end
function c22240123.xfilter(c,mg)
	return c22240123.IsSolid(c) and c:IsType(TYPE_XYZ)
end
function c22240123.mfilter1(c,mg,exg)
	return mg:IsExists(c22240123.mfilter2,1,c,c,exg)
end
function c22240123.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c22240123.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c22240123.sfilter,tp,LOCATION_GRAVE,0,nil,e)
	local exg=Duel.GetMatchingGroup(c22240123.xfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 and mg:GetCount()>1
		and exg:GetCount()>0 end
	local sg1=mg:FilterSelect(tp,c22240123.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	local sg2=mg:FilterSelect(tp,c22240123.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
end
function c22240123.filter2(c,e)
	return bit.band(c:GetType(),0x81)==0x81 and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsRelateToEffect(e)
end
function c22240123.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp)<1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c22240123.filter2,nil,e)
	if g:GetCount()<2 then return end
	local xyzg=Duel.GetMatchingGroup(c22240123.xfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(xyz,g)
		xyz:CompleteProcedure()
	end
end