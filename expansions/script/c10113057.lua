--未知飞龙
function c10113057.initial_effect(c)
	--xyzlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)  
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113057,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(aux.XyzCondition(nil,4,2,5))
	e1:SetTarget(aux.XyzTarget(nil,4,2,5))
	e1:SetOperation(aux.XyzOperation(nil,4,2,5))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113057,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c10113057.xyzcon)
	e2:SetOperation(c10113057.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--gaineffect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10113057,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c10113057.rmcon)
	e3:SetTarget(c10113057.rmtg)
	e3:SetOperation(c10113057.rmop)
	c:RegisterEffect(e3)
end
function c10113057.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10113057.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()~=0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAbleToGrave,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c10113057.rmop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	if og:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=og:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
	   e:GetHandler():CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000)
	end
end
function c10113057.mfilter(c,xyzc,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and c:IsCanBeXyzMaterial(xyzc) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c10113057.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local minc=1
	local maxc=99
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local mg=nil
	if og then
		mg=og:Filter(c10113057.mfilter,nil,c,tp)
	else
		mg=Duel.GetMatchingGroup(c10113057.mfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	end
	return maxc>=1 and mg:GetCount()>0
end
function c10113057.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c10113057.mfilter,nil,c,tp)
		else
			mg=Duel.GetMatchingGroup(c10113057.mfilter,tp,LOCATION_MZONE,0,nil,c,tp)
		end
		local minc=1
		local maxc=99
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:Select(tp,1,maxc,nil)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

