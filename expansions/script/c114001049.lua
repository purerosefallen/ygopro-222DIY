--★小人（ホムンクルス）の片割れ スロウス
function c114001049.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c114001049.xyzcon)
	e1:SetOperation(c114001049.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114001049.reptg)
    c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c114001049.aclimit)
	e4:SetCondition(c114001049.actcon)
	c:RegisterEffect(e4)
end

function c114001049.xyzfilter(c)
	return c:IsSetCard(0x221) and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114001049.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-1 then 
		local chkct=true
		local lvb=c114001049.lvchk(c:GetControler())
		local mct=0 -- count suitable monsters
		local j=0
			for i=4,lvb do
				j=0
				chkct=true
				repeat
					if Duel.CheckXyzMaterial(c,c114001049.xyzfilter,i,j+1,j+1,og) then
						j=j+1
					else
						chkct=false
					end
				until not chkct
				mct=mct+j
				if mct>=2 then break end
			end
		if mct>=2 then abcount=abcount+2 end
	end
	--if 2<=ct then return false end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-2 then
		if Duel.CheckXyzMaterial(c,nil,5,3,3,og) then abcount=abcount+1 end 
	end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114001049.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114001049,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114001049,0),aux.Stringid(114001049,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			local ag=Duel.GetMatchingGroup(c114001049.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local pg=Group.CreateGroup()
			local chkpg=false
			local agtg=ag:GetFirst()
			local lvb=c114001049.lvchk(tp)
			while agtg do
				chkpg=false
				for i=4,lvb do
					if Duel.CheckXyzMaterial(c,nil,i,1,1,Group.FromCards(agtg)) then pg:AddCard(agtg) chkpg=true end
					if chkpg then break end
				end
				agtg=ag:GetNext()
			end
			mg=pg:Select(tp,2,pg:GetCount(),nil)
		else
			mg=Duel.SelectXyzMaterial(tp,c,nil,5,3,3)
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
	end
end

--
function c114001049.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end
--actlimit
function c114001049.aclimit(e,re,tp)
	return not ( re:GetHandler():IsLevelAbove(5) or re:GetHandler():IsRankAbove(5) )
end
function c114001049.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end



--definition
function c114001049.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114001049)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114001049.lvchk(tp)
		for i=4,lvb do
			if i==5 then 
				if c:IsXyzLevel(mgtg,i) then jud=true end
			else
				if c:IsXyzLevel(mgtg,i) and c:IsSetCard(0x221) then jud=true end
			end
			if jud then break end
		end
		return jud
	else
		return c:GetLevel()==5 or ( c:IsSetCard(0x221) and c:GetLevel()>=4 )
	end
end

function c114001049.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
c114001049.xyz_filter=c114001049.xyzdef
c114001049.xyz_count=2
--end of definitiion