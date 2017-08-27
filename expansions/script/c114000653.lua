--★小人（ホムンクルス）の片割（かたわ）れ ラース
function c114000653.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114000653.xyzcon)
	e2:SetOperation(c114000653.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114000653.reptg)
    c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c114000653.discon)
	e4:SetCost(c114000653.discost)
	e4:SetTarget(c114000653.distg)
	e4:SetOperation(c114000653.disop)
	c:RegisterEffect(e4)
end
--
function c114000653.xyzfilter(c)
	return c:IsSetCard(0x221) and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114000653.xyzfil0(c)
	return c:IsRace(RACE_WARRIOR)
end
function c114000653.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-2 then 
		local chkct=true
		local lvb=c114000653.lvchk(c:GetControler())
		local mct=0 -- count suitable monsters
		local j=0
			for i=5,lvb do
				j=0
				chkct=true
				repeat
					if Duel.CheckXyzMaterial(c,c114000653.xyzfilter,i,j+1,j+1,og) then
						j=j+1
					else
						chkct=false
					end
				until not chkct
				mct=mct+j
				if mct>=3 then break end
			end
		if mct>=3 then abcount=abcount+2 end
	end
	--if 2<=ct then return false end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-3 then
		if Duel.CheckXyzMaterial(c,c114000653.xyzfil0,7,4,4,og) then abcount=abcount+1 end 
	end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114000653.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000653,3))
			sel=Duel.SelectOption(tp,aux.Stringid(114000653,0),aux.Stringid(114000653,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			local ag=Duel.GetMatchingGroup(c114000653.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local pg=Group.CreateGroup()
			local chkpg=false
			local agtg=ag:GetFirst()
			local lvb=c114000653.lvchk(tp)
			while agtg do
				chkpg=false
				for i=5,lvb do
					if Duel.CheckXyzMaterial(c,nil,i,1,1,Group.FromCards(agtg)) then pg:AddCard(agtg) chkpg=true end
					if chkpg then break end
				end
				agtg=ag:GetNext()
			end
			mg=pg:Select(tp,3,pg:GetCount(),nil)
		else
			mg=Duel.SelectXyzMaterial(tp,c,c114000653.xyzfil0,7,4,4)
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
	end
end

--

function c114000653.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    local g=e:GetHandler():GetOverlayGroup()
    Duel.SendtoGrave(g,REASON_EFFECT)
	return true
end
--negate function
function c114000653.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
	and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
	and Duel.IsChainNegatable(ev)
end
function c114000653.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114000653.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c114000653.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(114000653,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end




--definition
function c114000653.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114000653)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114000653.lvchk(tp)
		for i=5,lvb do
			if i==7 then 
				if c:IsXyzLevel(mgtg,i) and ( c:IsSetCard(0x221) or c114000653.xyzfil0(c) ) then jud=true end
			else
				if c:IsXyzLevel(mgtg,i) and c:IsSetCard(0x221) then jud=true end
			end
			if jud then break end
		end
		return jud
	else
		return ( c:GetLevel()==7 and c114000653.xyzfil0(c) ) or ( c:IsSetCard(0x221) and c:GetLevel()>=5 )
	end
end

function c114000653.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
c114000653.xyz_filter=c114000653.xyzdef
c114000653.xyz_count=3
--end of definitiion