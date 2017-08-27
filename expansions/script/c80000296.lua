--传说中的口袋妖怪 雷公
function c80000296.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c80000296.xyzcon)
	e1:SetOperation(c80000296.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000296.efilter)
	c:RegisterEffect(e2)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000296,3))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80000296.cost2)
	e3:SetTarget(c80000296.destg)
	e3:SetOperation(c80000296.desop)
	c:RegisterEffect(e3) 
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000296.splimit)
	c:RegisterEffect(e4)  
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c80000296.condition)
	e5:SetOperation(c80000296.activate)
	c:RegisterEffect(e5) 
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetType(EFFECT_TYPE_QUICK_F)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(c80000296.condition1)
	e6:SetOperation(c80000296.activate1)
	c:RegisterEffect(e6) 
	--spsummon limit
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c80000296.splimit)
	c:RegisterEffect(e8)
	if not c80000296.xyz_filter then
		c80000296.xyz_filter=function(mc) return mc:IsType(TYPE_XYZ) and mc:IsSetCard(0x2d0) and mc:IsAttribute(ATTRIBUTE_LIGHT) and mc:IsCanBeXyzMaterial(c) end
	end
end   
function c80000296.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end 
function c80000296.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x2d0) and c:GetOverlayCount()>0 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeXyzMaterial(xyzc)
end
function c80000296.xyzfilter1(c,g,ct)
	return g:IsExists(c80000296.xyzfilter2,ct,c,c:GetRank())
end
function c80000296.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c80000296.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=3
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c80000296.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c80000296.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return maxc>=3 and mg:IsExists(c80000296.xyzfilter1,1,nil,mg,ct)
end
function c80000296.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c80000296.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c80000296.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=3
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c80000296.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c80000296.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c80000296.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end 
function c80000296.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000296.filter(c)
	return c:IsAbleToRemove()
end
function c80000296.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80000296.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0,nil)
end
function c80000296.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000296.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c80000296.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000296.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c80000296.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_SPELL)
	if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80000296,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		if Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c80000296.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c80000296.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_TRAP)
	if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80000296,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		if Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end